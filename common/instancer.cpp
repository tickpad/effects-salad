#include "instancer.h"

Instancer::Instancer() :
    Drawable(), 
    primCount(5)
{
}

/* virtual */
Instancer::~Instancer() {
}


/* virtual */
void
Instancer::Init() {
    /*
    float x[] = {1,2,3,4,5};
    GLuint attr = 9;
    vao.AddVertexAttribute(attr, 1, FloatList(x, x+5));
    */
}

/* virtual */
void
Instancer::Draw() {
    vao.Bind();

    if (vao.indexCount == 0) {
        glDrawArraysInstanced(GL_TRIANGLE_STRIP,
                                0,
                                4, //vao.vertexCount / 3,
                                primCount);
    } else {
        glDrawElementsInstanced(GL_TRIANGLES,
                                vao.vertexCount / 3,
                                GL_UNSIGNED_INT,
                                NULL, /* the indices are in the vao */
                                primCount);

    }
    pezCheck(glGetError() == GL_NO_ERROR, "Draw..Instanced failed");
}

/* virtual */
void
Instancer::Update() {

}
