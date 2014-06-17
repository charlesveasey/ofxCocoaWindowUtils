#include "ofxCocoaWindowUtils.h"
#include "ofxCocoaWindowU.h"

void menuCallback(vector<std::string> files) {
    ofxCocoaWindowUtils::mCallback(files);
}

void ofxCocoaWindowUtils::mCallback(vector<std::string> files) {
    ofDragInfo dragInfo;
    
    for (int i=0; i<files.size(); i++) {
        dragInfo.files.push_back(files[i]);
    }
    
    if (dragInfo.files.size())
        ofNotifyDragEvent(dragInfo);
}

void ofxCocoaWindowUtils::setup(int transparentType, int x, int y, int w, int h, bool showBorder) {
	createWindow(transparentType, x, y, w, h, showBorder);
}
