#pragma once

#include "common/camera.h"
#include "common/curve.h"
#include "common/effect.h"
#include "common/init.h"
#include "common/instancer.h"
#include "common/normalField.h"
#include "common/surface.h"
#include "common/texture.h"
#include "common/tube.h"
#include "common/quad.h"

#include "fx/fireFlies.h"
#include "fx/fullscreen.h"
#include "fx/ground.h"
#include "fx/milkyway.h"
#include "fx/tree.h"


class GrassTreeGrow : public Effect {
    Surface _surface;
    Quad _quad;
    Tube _tube;
    FireFlies _fireFlies;
    std::vector<Tube> _tubes;
    AnimCurve<glm::vec3> cameraPoints;
    AnimCurve<glm::vec3> introCameraPoints;
    Milkyway _milkyway;
    Tree _tree;

public:

    bool bloomMode;

    Ground* _ground;
    Fullscreen* fullscreen;

    GrassTreeGrow() : Effect(), bloomMode(false) {}
    virtual ~GrassTreeGrow() {} 
   
    virtual void Init();

    virtual void Update();

    virtual void Draw();
};

