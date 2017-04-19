#include <iostream>
#include <opencv2/opencv.hpp>
#include <cstdio>
#include <vector>
using namespace std;
using namespace cv;

typedef struct feature {
	int y;
	int x;
	unsigned char s;
	unsigned char score;
} FEATURE;

const int MAX_CANDIDATE = 16;
Mat img;
vector<FEATURE> feature_candidate;
int limit = 30;

void featureDetection()
{
	unsigned char candidate[MAX_CANDIDATE];
	unsigned char comp[MAX_CANDIDATE]; // darker: 1, similar: 2, brighter: 3

	for (int y = 3; y < img.rows - 3; y++) {
		for (int x = 3; x < img.cols - 3; x++) {
			int lower = (img.at<Vec3b>(y, x)[0] - limit) < 0 ? 0 : (img.at<Vec3b>(y, x)[0] - limit);
			int upper = (img.at<Vec3b>(y, x)[0] + limit) > 255 ? 255 : (img.at<Vec3b>(y, x)[0] + limit);

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

			for (int i = 0; i < MAX_CANDIDATE; i++)
				comp[i] = (candidate[i] <= lower) ? 1 : (candidate[i] >= upper) ? 3 : 2;

			for (int i = 0; i < MAX_CANDIDATE; i++) {
				if (comp[i] == 2)
					continue;

				bool check = true;
				for (int j = 1; j < 9; j++) {
					if (comp[i] != comp[(i + j) % MAX_CANDIDATE]) {
						check = false;
						break;
					}
				}
				
				if (check) {
					FEATURE feature;
					feature.y = y;
					feature.x = x;
					feature.s = comp[i];
					
					feature_candidate.push_back(feature);
					break;
				}
			}
		}
	}

	/*
	for (int i = 0; i < feature_candidate.size(); i++) {
		FEATURE feature = feature_candidate[i];
		img.ptr<Vec3b>(feature.y)[feature.x][1] = 255;
	}
	*/
}

void featureScore()
{
	unsigned char candidate[MAX_CANDIDATE];
	unsigned char comp[MAX_CANDIDATE]; // darker: 1, similar: 2, brighter: 3

	for (int index = 0; index < feature_candidate.size(); index++) {
		FEATURE feature = feature_candidate[index];
		int y = feature.y;
		int x = feature.x;
		
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

		int min = limit;
		int max = 255;

		while (min < max - 1) {
			int avg = (((min + max) / 2) < 0) ? 0 : (((min + max) / 2) > 255) ? 255 : (min + max) / 2;
			int lower = (img.at<Vec3b>(y, x)[0] - avg) < 0 ? 0 : (img.at<Vec3b>(y, x)[0] - avg);
			int upper = (img.at<Vec3b>(y, x)[0] + avg) > 255 ? 255 : (img.at<Vec3b>(y, x)[0] + avg);

			for (int i = 0; i < MAX_CANDIDATE; i++)
				comp[i] = (candidate[i] <= lower) ? 1 : (candidate[i] >= upper) ? 3 : 2;
			
			bool checkCorner = true;
			for (int i = 0; i < MAX_CANDIDATE; i++) {
				if (comp[i] == 2)
					continue;

				bool check = true;
				for (int j = 1; j < 9; j++) {
					if (comp[i] != comp[(i + j) % MAX_CANDIDATE]) {
						check = false;
						break;
					}
				}
				
				if (check) {
					min = avg;
					checkCorner = false;
					break;
				}
			}

			if (checkCorner)
				max = avg;
		}

		feature_candidate[index].score = max;
	}
}

void suppression()
{
	unsigned char corner[512][512] = { {0} };
	unsigned char adj[8];

	for (int i = 0; i < feature_candidate.size(); i++) {
		FEATURE feature = feature_candidate[i];
		corner[feature.y][feature.x] = feature.score;
	}
	
	for (int y = 1; y < img.rows - 1; y++) {
		for (int x = 1; x < img.cols - 1; x++) {
			if (corner[y][x] != 0) {
				adj[0] = corner[y - 1][x];
				adj[1] = corner[y - 1][x + 1];
				adj[2] = corner[y][x + 1];
				adj[3] = corner[y + 1][x + 1];
				adj[4] = corner[y + 1][x];
				adj[5] = corner[y + 1][x - 1];
				adj[6] = corner[y][x - 1];
				adj[7] = corner[y - 1][x - 1];

				for (int i = 0; i < 8; i++)
					if (corner[y][x] < adj[i])
						corner[y][x] = 0;
			}
		}
	}
	

	for (int i = 0; i < feature_candidate.size(); i++) {
		img.ptr<Vec3b>(feature_candidate[i].y)[feature_candidate[i].x][1] = 255;
	
		img.ptr<Vec3b>(feature_candidate[i].y-1)[feature_candidate[i].x][1] = 255;
		img.ptr<Vec3b>(feature_candidate[i].y+1)[feature_candidate[i].x][1] = 255;
		img.ptr<Vec3b>(feature_candidate[i].y)[feature_candidate[i].x-1][1] = 255;
		img.ptr<Vec3b>(feature_candidate[i].y)[feature_candidate[i].x+1][1] = 255;
		
	}
	for (int y = 0; y < img.rows; y++)
		for (int x = 0; x < img.cols; x++)
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
 
int main() 
{
	img = imread("test.tif", CV_LOAD_IMAGE_COLOR);
    if (img.empty())
        return -1;

	unsigned char r, g, b;
	for (int y = 0; y < img.rows; y++) {
		Vec3b* pixel = img.ptr<Vec3b>(y);

		for (int x = 0; x < img.cols; x++) {
			r = pixel[x][2];
			g = pixel[x][1];
			b = pixel[x][0];

			int avg = (((r + g + b) / 3) > 255) ? 255 : (r + g + b) / 3;
			pixel[x][2] = avg;
			pixel[x][1] = avg;
			pixel[x][0] = avg;
		}
	}

	featureDetection();
	featureScore();
	suppression();

	imshow("fast9", img);
	waitKey(0);
	destroyWindow("fast9");

    return 0;
}