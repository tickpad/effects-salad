#pragma once

#include <vector>

#include "common/camera.h"
#include "common/effect.h"
#include "common/init.h"
#include "common/normalField.h"
#include "common/quad.h"
#include "common/tube.h"


// simple effect used to test framework features

class Tree : public Effect {
    std::vector<Tube*> _branches;

public:

    Tree() : Effect() 
    { 
    }
   
    virtual void Init();

    virtual void Update();

    virtual void Draw();
};

