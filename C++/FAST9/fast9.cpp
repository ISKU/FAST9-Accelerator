#include <iostream>
#include <opencv2/opencv.hpp>
#include <math.h>
#include <vector>
#include <fstream>
using namespace std;
using namespace cv;

const unsigned char DARKER = 1;
const unsigned char SIMILAR = 2;
const unsigned char BRIGHTER = 3;
const int RED = 2;
const int GREEN = 1;
const int BLUE = 0;
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
			r = pixel[x][RED];
			g = pixel[x][GREEN];
			b = pixel[x][BLUE];

			// 3 channel average
			int avg = (((r + g + b) / 3) > 0xff) ? 0xff : (r + g + b) / 3; 
			pixel[x][RED] = (unsigned char) avg;
			pixel[x][GREEN] = (unsigned char) avg;
			pixel[x][BLUE] = (unsigned char) avg;
		}
	}
}

void getAdjacentSixteenPixels(unsigned char* candidate, int y, int x)
{
	candidate[0] = img.at<Vec3b>(y - 3, x)[BLUE];
	candidate[1] = img.at<Vec3b>(y - 3, x + 1)[BLUE];
	candidate[2] = img.at<Vec3b>(y - 2, x + 2)[BLUE];
	candidate[3] = img.at<Vec3b>(y - 1, x + 3)[BLUE];
	candidate[4] = img.at<Vec3b>(y, x + 3)[BLUE];
	candidate[5] = img.at<Vec3b>(y + 1, x + 3)[BLUE];
	candidate[6] = img.at<Vec3b>(y + 2, x + 2)[BLUE];
	candidate[7] = img.at<Vec3b>(y + 3, x + 1)[BLUE];
	candidate[8] = img.at<Vec3b>(y + 3, x)[BLUE];
	candidate[9] = img.at<Vec3b>(y + 3, x - 1)[BLUE];
	candidate[10] = img.at<Vec3b>(y + 2, x - 2)[BLUE];
	candidate[11] = img.at<Vec3b>(y + 1, x - 3)[BLUE];
	candidate[12] = img.at<Vec3b>(y, x - 3)[BLUE];
	candidate[13] = img.at<Vec3b>(y - 1, x - 3)[BLUE];
	candidate[14] = img.at<Vec3b>(y - 2, x - 2)[BLUE];
	candidate[15] = img.at<Vec3b>(y - 3, x - 1)[BLUE];
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
	int lower = (img.at<Vec3b>(y, x)[BLUE] - threshold) < 0 ? 0 : (img.at<Vec3b>(y, x)[BLUE] - threshold);
	int upper = (img.at<Vec3b>(y, x)[BLUE] + threshold) > 0xff ? 0xff : (img.at<Vec3b>(y, x)[BLUE] + threshold);

	for (int i = 0; i < MAX_CANDIDATE; i++)
		compare[i] = (candidate[i] < lower) ? DARKER : (candidate[i] > upper) ? BRIGHTER : SIMILAR;
}

bool findNineConsecutivePixel(unsigned char* compare, int y, int x, bool allowPush)
{
	for (int i = 0; i < MAX_CANDIDATE; i++) {
		if (compare[i] == SIMILAR) // Similar pixel is not feature
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
	
	/* This below is debug code
	ofstream outFile("FeatureDetection_Output.txt");
	for (int i = 0; i < feature_candidate.size(); i++)
		outFile << dec 
		<< "y: " << feature_candidate[i].y 
		<< ", x: " << feature_candidate[i].x 
		<< ", addr: " << (feature_candidate[i].y * 180 + feature_candidate[i].x) 
		<< ", data: " << hex << (int) (img.at<Vec3b>(feature_candidate[i].y, feature_candidate[i].x)[BLUE]) << " " << endl;
	outFile.close();
	*/
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
			int avg = (((min + max) / 2) < 0) ? 0 : (((min + max) / 2) > 0xff) ? 0xff : (min + max) / 2;
			comparePixel(compare, candidate, feature.y, feature.x, avg);

			if (findNineConsecutivePixel(compare, feature.y, feature.x, false))
				min = avg;
			else
				max = avg;
		}

		feature_candidate[index].score = max; // save feature score
	}

	/* This below is debug code (Score decision using formula)
	ofstream outFile("FeatureScore_Output.txt");
	for (int index = 0; index < feature_candidate.size(); index++) {
		FEATURE feature = feature_candidate[index];
		getAdjacentSixteenPixels(candidate, feature.y, feature.x);
		comparePixel(compare, candidate, feature.y, feature.x, limit);
		findNineConsecutivePixel(compare, feature.y, feature.x, false);

		int setDark = 0;
		int setBright = 0;
		for (int i = 0; i < 16; i++) {
			if (compare[i] == DARKER)
				setDark += abs((int) img.at<Vec3b>(feature.y, feature.x)[BLUE] - (int) candidate[i]) - limit;
			else if (compare[i] == BRIGHTER)
				setBright += abs((int) candidate[i] - (int) img.at<Vec3b>(feature.y, feature.x)[BLUE]) - limit;
		}

		outFile << dec 
		<< "y: " << feature.y 
		<< ", x: " << feature.x 
		<< ", addr: " << (feature.y * 180 + feature.x) 
		<< ", score: " << hex << (((setDark > setBright) ? setDark : setBright) & 0xff) << endl;
		feature_candidate[index].score = (((setDark > setBright) ? setDark : setBright) & 0xff);
	}
	outFile.close();
	*/
}

void oneFeatureScore()
{
	// This function is debug code
	// input: y, x
	// result: only one feature score, console output

	unsigned char candidate[MAX_CANDIDATE];
	unsigned char compare[MAX_CANDIDATE];
	
	// test coordinate
	int y = 20; 
	int x = 55; 

	// Using binary search
	getAdjacentSixteenPixels(candidate, y, x);
	int min = limit;
	int max = 255;

	while (min < max - 1) {
		int avg = (((min + max) / 2) < 0) ? 0 : (((min + max) / 2) > 0xff) ? 0xff : (min + max) / 2;
		comparePixel(compare, candidate, y, x, avg);

		printf("%d: ", avg);
		for (int i = 0; i < 16; i++)
			printf("%d ", compare[i]);
		printf("\n");

		if (findNineConsecutivePixel(compare, y, x, false))
			min = avg;
		else
			max = avg;
	}
	printf("score: %d\n", max);

	// Using formula
	int setDark = 0;
	int setBright = 0;
	comparePixel(compare, candidate, y, x, limit);
	findNineConsecutivePixel(compare, y, x, false);

	for (int i = 0; i < 16; i++) {
		if (compare[i] == DARKER)
			setDark += abs(img.at<Vec3b>(y, x)[BLUE] - candidate[i]) - limit;
		else if (compare[i] == BRIGHTER)
			setBright += abs(candidate[i] - img.at<Vec3b>(y, x)[BLUE]) - limit;
	}
	printf("score: %d\n", (setDark > setBright) ? setDark : setBright);
}

void drawCandidateFeaturePoint()
{
	for (int i = 0; i < feature_candidate.size(); i++) {
		img.ptr<Vec3b>(feature_candidate[i].y)[feature_candidate[i].x][GREEN] = 0xff;
		img.ptr<Vec3b>(feature_candidate[i].y)[feature_candidate[i].x][RED] = 0;
		img.ptr<Vec3b>(feature_candidate[i].y)[feature_candidate[i].x][BLUE] = 0;

		img.ptr<Vec3b>(feature_candidate[i].y - 1)[feature_candidate[i].x][GREEN] = 0xff;
		img.ptr<Vec3b>(feature_candidate[i].y + 1)[feature_candidate[i].x][GREEN] = 0xff;
		img.ptr<Vec3b>(feature_candidate[i].y)[feature_candidate[i].x - 1][GREEN] = 0xff;
		img.ptr<Vec3b>(feature_candidate[i].y)[feature_candidate[i].x + 1][GREEN] = 0xff;
	}
}

void drawFeature(int y, int x)
{
	img.ptr<Vec3b>(y)[x][RED] = 0xff;
	img.ptr<Vec3b>(y)[x][GREEN] = 0;
	img.ptr<Vec3b>(y)[x][BLUE] = 0;
	
	img.ptr<Vec3b>(y - 1)[x][RED] = 0xff;
	img.ptr<Vec3b>(y - 1)[x][GREEN] = 0;
	img.ptr<Vec3b>(y - 1)[x][BLUE] = 0;
	img.ptr<Vec3b>(y + 1)[x][RED] = 0xff;
	img.ptr<Vec3b>(y + 1)[x][GREEN] = 0;
	img.ptr<Vec3b>(y + 1)[x][BLUE] = 0;
	img.ptr<Vec3b>(y)[x - 1][RED] = 0xff;
	img.ptr<Vec3b>(y)[x - 1][GREEN] = 0;
	img.ptr<Vec3b>(y)[x - 1][BLUE] = 0;
	img.ptr<Vec3b>(y)[x + 1][RED] = 0xff;
	img.ptr<Vec3b>(y)[x + 1][GREEN] = 0;
	img.ptr<Vec3b>(y)[x + 1][BLUE] = 0;
}

void nonMaximallySuppression()
{
	unsigned char corner[MAX_ROWS][MAX_COLS] = {{0}};
	unsigned char adjacency[MAX_ADJACENCY];
	drawCandidateFeaturePoint();

	// Set existing features to corner array
	for (int i = 0; i < feature_candidate.size(); i++)
		corner[feature_candidate[i].y][feature_candidate[i].x] = feature_candidate[i].score;

	// Non-maximal suppression
	for (int y = 4; y < img.rows - 4; y++) {
		for (int x = 4; x < img.cols - 4; x++) {
			if (corner[y][x] != 0) {
				getAdjacentEightPixels(adjacency, corner, y, x);

				bool check = true;
				for (int i = 0; i < MAX_ADJACENCY; i++)
					if (corner[y][x] < adjacency[i]) {
						check = false;
						break;
					}

				if (check)
					drawFeature(y, x);
			}
		}
	}

	/* This below is debug code
	ofstream outFile("NMS_Output.txt");
	for (int y = 4; y < img.rows - 4; y++) {
		for (int x = 4; x < img.cols - 4; x++) {
			if (corner[y][x] != 0) {
				getAdjacentEightPixels(adjacency, corner, y, x);

				bool check = true;
				for (int i = 0; i < MAX_ADJACENCY; i++)
					if (corner[y][x] < adjacency[i]) {
						check = false;
						break;
					}

				if (check) {
					drawFeature(y, x);
					outFile << dec 
					<< "y: " << y 
					<< ", x: " << x 
					<< ", addr: " << (y * 180 + x) << endl;
				}
			}
		}
	}
	outFile.close();
	*/
}

void fast9()
{
	featureDetection(); // stage 1
	featureScore(); // stage 2
	nonMaximallySuppression(); // stage 3
}

int main() 
{
	img = imread("untitled.png", CV_LOAD_IMAGE_COLOR);
	if (img.empty())
		return -1;
	
	convertGrayScale(); // Convert an image to gray scale
	fast9(); // FAST-9 Algorithm

	imshow("fast9", img);
	waitKey(0);
	destroyWindow("fast9");
	return 0;
}