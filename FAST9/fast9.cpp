#include <iostream>
#include <opencv2/opencv.hpp>
#include <vector>
using namespace std;
using namespace cv;

const unsigned char DARKER = 1;
const unsigned char SIMILAR = 2;
const unsigned char BRIGHTER = 3;
const int MAX_CANDIDATE = 16;
const int MAX_CONSECUTIVE = 9;
const int MAX_ADJACENCY = 8;
const int MAX_ROWS = 512;
const int MAX_COLS = 512;

// Feature
typedef struct feature {
	int y;
	int x;
	unsigned char score;
	unsigned char s; // Darker: 1, Similar: 2, Brighter: 3
} FEATURE;

Mat img; // Image
vector<FEATURE> feature_candidate; // Candidate features found in stage 'Feature Detection'
int limit = 30; // Threshold

void convertGrayScale()
{
	unsigned char r, g, b;
	
	for (int y = 0; y < img.rows; y++) {
		Vec3b* pixel = img.ptr<Vec3b>(y);

		for (int x = 0; x < img.cols; x++) {
			r = pixel[x][2];
			g = pixel[x][1];
			b = pixel[x][0];

			// 3 channel average
			int avg = (((r + g + b) / 3) > 255) ? 255 : (r + g + b) / 3; 
			pixel[x][2] = (unsigned char) avg;
			pixel[x][1] = (unsigned char) avg;
			pixel[x][0] = (unsigned char) avg;
		}
	}
}

void getAdjacentSixteenPixels(unsigned char* candidate, int y, int x)
{
	candidate[0] = img.at<Vec3b>(y - 3, x)[0];
	candidate[1] = img.at<Vec3b>(y - 3, x + 1)[0];
	candidate[2] = img.at<Vec3b>(y - 2, x + 2)[0];
	candidate[3] = img.at<Vec3b>(y - 1, x + 3)[0];
	candidate[4] = img.at<Vec3b>(y, x + 3)[0];
	candidate[5] = img.at<Vec3b>(y + 1, x + 3)[0];
	candidate[6] = img.at<Vec3b>(y + 2, x + 2)[0];
	candidate[7] = img.at<Vec3b>(y + 3, x + 1)[0];
	candidate[8] = img.at<Vec3b>(y + 3, x)[0];
	candidate[9] = img.at<Vec3b>(y + 3, x - 1)[0];
	candidate[10] = img.at<Vec3b>(y + 2, x - 2)[0];
	candidate[11] = img.at<Vec3b>(y + 1, x - 3)[0];
	candidate[12] = img.at<Vec3b>(y, x - 3)[0];
	candidate[13] = img.at<Vec3b>(y - 1, x - 3)[0];
	candidate[14] = img.at<Vec3b>(y - 2, x - 2)[0];
	candidate[15] = img.at<Vec3b>(y - 3, x - 1)[0];
}

void getAdjacentEightPixels(unsigned char* adjacency, unsigned char (* corner)[MAX_COLS], int y, int x)
{
	adjacency[0] = corner[y - 1][x];
	adjacency[1] = corner[y - 1][x + 1];
	adjacency[2] = corner[y][x + 1];
	adjacency[3] = corner[y + 1][x + 1];
	adjacency[4] = corner[y + 1][x];
	adjacency[5] = corner[y + 1][x - 1];
	adjacency[6] = corner[y][x - 1];
	adjacency[7] = corner[y - 1][x - 1];
}

void comparePixel(unsigned char* compare, unsigned char* candidate, int y, int x, int threshold)
{
	int lower = (img.at<Vec3b>(y, x)[0] - threshold) < 0 ? 0 : (img.at<Vec3b>(y, x)[0] - threshold);
	int upper = (img.at<Vec3b>(y, x)[0] + threshold) > 255 ? 255 : (img.at<Vec3b>(y, x)[0] + threshold);

	for (int i = 0; i < MAX_CANDIDATE; i++)
		compare[i] = (candidate[i] <= lower) ? 1 : (candidate[i] >= upper) ? 3 : 2;
}

bool findNineConsecutivePixel(unsigned char* compare, int y, int x, bool allowPush)
{
	for (int i = 0; i < MAX_CANDIDATE; i++) {
		if (compare[i] == 2) // Similar pixel is not feature
			continue;

		bool consecutive = true;
		for (int j = 1; j < MAX_CONSECUTIVE; j++) {
			if (compare[i] != compare[(i + j) % MAX_CANDIDATE]) {
				consecutive = false; // No consecutive 9 pixel
				break;
			}
		}
		
		if (consecutive) { // Found feature
			if (allowPush) {
				FEATURE feature;
				feature.y = y;
				feature.x = x;
				feature.s = compare[i];
				feature_candidate.push_back(feature); // Add candidate feature
			}

			return true;
		}
	}

	return false;
}

void featureDetection()
{
	unsigned char candidate[MAX_CANDIDATE];
	unsigned char compare[MAX_CANDIDATE];

	for (int y = 3; y < img.rows - 3; y++) {
		for (int x = 3; x < img.cols - 3; x++) {
			getAdjacentSixteenPixels(candidate, y, x);
			comparePixel(compare, candidate, y, x, limit);
			findNineConsecutivePixel(compare, y, x, true);
		}
	}
}

void featureScore()
{
	unsigned char candidate[MAX_CANDIDATE];
	unsigned char compare[MAX_CANDIDATE];

	for (int index = 0; index < feature_candidate.size(); index++) {
		FEATURE feature = feature_candidate[index];
		getAdjacentSixteenPixels(candidate, feature.y, feature.x);

		int min = limit;
		int max = 255;

		while (min < max - 1) {
			int avg = (((min + max) / 2) < 0) ? 0 : (((min + max) / 2) > 255) ? 255 : (min + max) / 2;
			comparePixel(compare, candidate, feature.y, feature.x, avg);

			if (findNineConsecutivePixel(compare, feature.y, feature.x, false))
				min = avg;
			else
				max = avg;
		}

		feature_candidate[index].score = max; // save feature score
	}
}

void nonMaximallySuppression()
{
	unsigned char corner[MAX_ROWS][MAX_COLS] = {{0}};
	unsigned char adjacency[MAX_ADJACENCY];

	// Set existing features to corner array
	for (int i = 0; i < feature_candidate.size(); i++)
		corner[feature_candidate[i].y][feature_candidate[i].x] = feature_candidate[i].score;
	
	// Non-maximal suppression
	for (int y = 1; y < img.rows - 1; y++) {
		for (int x = 1; x < img.cols - 1; x++) {
			if (corner[y][x] != 0) {
				getAdjacentEightPixels(adjacency, corner, y, x);

				for (int i = 0; i < MAX_ADJACENCY; i++)
					if (corner[y][x] < adjacency[i])
						corner[y][x] = 0;
			}
		}
	}
	
	// Draw feature point
	for (int i = 0; i < feature_candidate.size(); i++) {
		img.ptr<Vec3b>(feature_candidate[i].y)[feature_candidate[i].x][1] = 255;
	
		img.ptr<Vec3b>(feature_candidate[i].y-1)[feature_candidate[i].x][1] = 255;
		img.ptr<Vec3b>(feature_candidate[i].y+1)[feature_candidate[i].x][1] = 255;
		img.ptr<Vec3b>(feature_candidate[i].y)[feature_candidate[i].x-1][1] = 255;
		img.ptr<Vec3b>(feature_candidate[i].y)[feature_candidate[i].x+1][1] = 255;
	}

	for (int y = 0; y < img.rows; y++) {
		for (int x = 0; x < img.cols; x++) {
			if (corner[y][x] != 0) {
				img.ptr<Vec3b>(y)[x][2] = 255;
				img.ptr<Vec3b>(y)[x][1] = 0;
				img.ptr<Vec3b>(y)[x][0] = 0;
				
				img.ptr<Vec3b>(y-1)[x][2] = 255;
				img.ptr<Vec3b>(y-1)[x][1] = 0;
				img.ptr<Vec3b>(y-1)[x][0] = 0;

				img.ptr<Vec3b>(y+1)[x][2] = 255;
				img.ptr<Vec3b>(y+1)[x][1] = 0;
				img.ptr<Vec3b>(y+1)[x][0] = 0;

				img.ptr<Vec3b>(y)[x-1][2] = 255;
				img.ptr<Vec3b>(y)[x-1][1] = 0;
				img.ptr<Vec3b>(y)[x-1][0] = 0;

				img.ptr<Vec3b>(y)[x+1][2] = 255;
				img.ptr<Vec3b>(y)[x+1][1] = 0;
				img.ptr<Vec3b>(y)[x+1][0] = 0;
			}
		}
	}
}

int main() 
{
	img = imread("test.tif", CV_LOAD_IMAGE_COLOR);
	if (img.empty())
		return -1;
	
	convertGrayScale(); // Convert an image to gray scale

	featureDetection(); // stage 1
	featureScore(); // stage 2
	nonMaximallySuppression(); // stage 3

	imshow("fast9", img);
	waitKey(0);
	destroyWindow("fast9");
	return 0;
}