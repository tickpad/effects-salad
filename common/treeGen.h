#pragma once

#include <vector>
#include <string>

#include "glm/glm.hpp"

#include "common/typedefs.h"

struct BranchDef {
    BranchDef() :
        name("0"),
        width(.15),
        levels(6),
        isLeaf(false),
        isTrunk(false)
    {
        level = levels;
        // brown
        color = glm::vec3(0.02, 0.01, 0.001);
        pos = glm::vec3(0,0,0);
        norm = glm::vec3(0,1,0);
    }

    std::string name;
    glm::vec3 color;
    glm::vec3 pos;
    glm::vec3 norm;
    float parentPercent;
    float width;
    int levels;
    float level;
    bool isLeaf;
    bool isTrunk;
    Vec3List cvs;
    FloatList widths;
};

class TreeSystem {
public:
    typedef std::vector<BranchDef*> BranchVec;
    
    BranchVec queue;
    BranchVec branches;

    // index i indicates how long branching depth i should be
    std::vector<float> lengths;

    // index i indicates how many children depth i should have
    std::vector<int> childCounts;

    // childDist[i].x indicates the minimum distance up the branch children will spawn
    // childDist[i].y indicates the range of randomness
    // typically these two numbers will add to 1.0, but it is not necessary
    std::vector<glm::vec2> childDist;

    // spherical coordinate angles to control the branching shape
    // the x value represents the z-angle [0, PI] (0 being the north pole and PI/2 being the equator)
    // and the y value indicates the latitude [0,2PI] 
    std::vector<glm::vec2> childAngles;


    TreeSystem() {
        // initialize default branching level values
        for (int i = 0; i < 1000; i++) {
            lengths.push_back((999.0-i) / 900.0);
        }
        /*
        lengths[3] *= 2;
        lengths[2] *= 2;
        */

        childCounts.push_back(280); //20
        childCounts.push_back(4); //4
        childCounts.push_back(4); //4
        childCounts.push_back(1); //1
        childCounts.push_back(3); //3
        childCounts.push_back(0);
        childCounts.push_back(0);

        childDist.insert(childDist.begin(), 10, glm::vec2());
        childDist[0] = glm::vec2(0.0, 1.0);
        childDist[1] = glm::vec2(0.2, 0.8);
        childDist[2] = glm::vec2(0.2, 0.8);
        childDist[3] = glm::vec2(0.3, 0.7);
        childDist[4] = glm::vec2(0.6, 0.4);

        childAngles.insert(childAngles.begin(), 10, glm::vec2());
        childAngles[0] = glm::vec2(0.5, 1.3);
        childAngles[1] = glm::vec2(0.5, 1.3);
        childAngles[2] = glm::vec2(0.5, 1.0);
        childAngles[3] = glm::vec2(0.7, 1.3);
        childAngles[4] = glm::vec2(0.5, 1.2);
    }


    void GrowAll();
    void GrowBranch();

}; 

