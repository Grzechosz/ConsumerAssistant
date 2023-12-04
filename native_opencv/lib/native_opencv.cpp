#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

// Avoiding name mangling
extern "C" {
    // Attributes to prevent 'unused' function from being removed and to make it visible
    __attribute__((visibility("default"))) __attribute__((used))
    const char* version() {
        return CV_VERSION;
    }

    __attribute__((visibility("default"))) __attribute__((used))
    void process_image(char* inputImagePath, char* outputImagePath) {
        Mat input = imread(inputImagePath, IMREAD_GRAYSCALE);
        Mat threshed, withContours;

        vector<vector<Point>> contours;
        vector<Vec4i> hierarchy;

        adaptiveThreshold(input, threshed, 255, ADAPTIVE_THRESH_GAUSSIAN_C, THRESH_BINARY_INV, 77, 6);
        findContours(threshed, contours, hierarchy, RETR_TREE, CHAIN_APPROX_TC89_L1);

        cvtColor(threshed, withContours, COLOR_GRAY2BGR);
        drawContours(withContours, contours, -1, Scalar(0, 255, 0), 4);

        imwrite(outputImagePath, withContours);
    }

    __attribute__((visibility("default"))) __attribute__((used))
    bool is_invert_needed(char* path) {
        Mat in =  imread(path);
        Mat grayscale_image;
        Mat binary_image;
        cvtColor(in, grayscale_image, COLOR_BGR2GRAY);
        threshold(grayscale_image, binary_image, 100, 255, THRESH_OTSU);

        Scalar lower(0);
        Scalar upper(0);

        Mat blackColorMask;
        inRange(binary_image, lower, upper, blackColorMask);
        medianBlur(blackColorMask, blackColorMask, 9);
        vector<vector<Point> > contours;
        findContours(blackColorMask, contours, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);
        int blackMaxArea = 0;
        for (size_t i = 0; i < contours.size(); i++)
        {
            int area = contourArea(contours[i]);
            if (blackMaxArea < area )
            {
                blackMaxArea = area;
            }
        }
        Mat whiteColorMask;
        vector<vector<Point> > contours2;
        bitwise_not(blackColorMask,whiteColorMask);

        findContours(whiteColorMask, contours2, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);
        int whiteMaxArea = 0;
        for (size_t i = 0; i < contours2.size(); i++)
        {
            int area = contourArea(contours2[i]);
            if (whiteMaxArea < area)
            {
                whiteMaxArea = area;
            }
        }

        if (whiteMaxArea > blackMaxArea)
        {
            return 0;
        }
        return 1;
    }

    __attribute__((visibility("default"))) __attribute__((used))
    void invert_image(const char* inputPath, const char* outputPath) {
        Mat input_image = imread(inputPath);
        Mat processed_image;
        bitwise_not(input_image, processed_image);
        imwrite(outputPath, processed_image);
    }
}