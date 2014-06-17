#pragma once
#include "ofMain.h"

class ofxCocoaWindowUtils {
    
public:
	static const int SCREENSAVER = 0;
	static const int DESKTOPBG = 1;
	static const int NORMAL = 2;	
    static void mCallback(vector<std::string> files);

	void setup(int transparentType = 2, int x=0, int y=0, int w=0, int h=0, bool showBorder=true);
};