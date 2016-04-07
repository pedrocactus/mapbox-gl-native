#ifndef MBGL_ALGORITHM_GENERATE_CLIP_IDS
#define MBGL_ALGORITHM_GENERATE_CLIP_IDS

#include <mbgl/tile/tile_id.hpp>
#include <mbgl/util/clip_id.hpp>

#include <set>
#include <vector>
#include <map>

namespace mbgl {
namespace algorithm {

class ClipIDGenerator {
private:
    struct Leaf {
        Leaf(ClipID&);
        void add(const CanonicalTileID &p);
        bool operator==(const Leaf &other) const;

        std::set<CanonicalTileID> children;
        ClipID& clip;
    };

    uint8_t bit_offset = 0;
    std::multimap<UnwrappedTileID, Leaf> pool;

public:
    template <typename Renderables>
    void update(Renderables& renderables);

    std::map<UnwrappedTileID, ClipID> getStencils() const;
};

} // namespace algorithm
} // namespace mbgl

#endif
