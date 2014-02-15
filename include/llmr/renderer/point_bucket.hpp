#ifndef LLMR_RENDERER_POINTBUCKET
#define LLMR_RENDERER_POINTBUCKET

#include <llmr/renderer/bucket.hpp>
#include <llmr/style/bucket_description.hpp>
#include <llmr/geometry/elements_buffer.hpp>
#include <llmr/geometry/point_buffer.hpp>

#include <vector>
#include <memory>

#ifndef BUFFER_OFFSET
#define BUFFER_OFFSET(i) ((char *)nullptr + (i))
#endif

namespace llmr {

class Style;
class PointVertexBuffer;
class BucketDescription;
class PointShader;
struct Coordinate;
struct pbf;

class PointBucket : public Bucket {
    typedef ElementGroup<PointShader> group_type;
public:
    PointBucket(const std::shared_ptr<PointVertexBuffer>& vertexBuffer,
                const std::shared_ptr<PointElementsBuffer>& elementsBuffer,
                const BucketDescription& bucket_desc);

    virtual void render(Painter& painter, const std::string& layer_name, const Tile::ID& id);

    void addGeometry(pbf& data);
    void addGeometry(Coordinate& point);

    bool hasPoints() const;

    void drawPoints(PointShader& shader);

public:
    const BucketGeometryDescription geometry;

private:
    std::shared_ptr<PointVertexBuffer> vertexBuffer;
    std::shared_ptr<PointElementsBuffer> elementsBuffer;

    const uint32_t vertex_start;
    const uint32_t elements_start;

    std::vector<group_type> groups;
};

}

#endif
