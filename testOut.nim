import ./src/editlyconf
import std/json
echo pretty newEditlyConfig(
  outPath = "./out.mp4",
  clips = newEditlyClips(
    newEditlyClip(
      layers = newEditlyLayers(
        newEditlyLayer(
          kind = image,
          path = "image path",
        ),
      ),

      transition = newEditlyTransition(
        duration = 1,
        audioInCurve = squ,
      ),

      duration = 3,
    ),
    newEditlyClip(
      layers = newEditlyLayers(
        newEditlyLayer(
          kind = image,
          path = "image path",
        ),
      ),

      duration = 3,
    ),
    newEditlyClip(
      layers = newEditlyLayers(
        newEditlyLayer(
          kind = image,
          path = "image path",
        ),
      ),

      duration = 3,
    ),
    newEditlyClip(
      layers = newEditlyLayers(
        newEditlyLayer(
          kind = image,
          path = "image path",
        ),
      ),

      duration = 3,
    ),
    newEditlyClip(
      layers = newEditlyLayers(
        newEditlyLayer(
          kind = image,
          path = "image path",
        ),
      ),

      duration = 3,
    ),
    newEditlyClip(
      layers = newEditlyLayers(
        newEditlyLayer(
          kind = image,
          path = "image path",
        ),
      ),

      duration = 3,
    ),
    newEditlyClip(
      layers = newEditlyLayers(
        newEditlyLayer(
          kind = image,
          path = "image path",
        ),
      ),

      duration = 3,
    ),
    newEditlyClip(
      layers = newEditlyLayers(
        newEditlyLayer(
          kind = image,
          path = "image path",
        ),
      ),

      duration = 3,
    ),
    newEditlyClip(
      layers = newEditlyLayers(
        newEditlyLayer(
          kind = image,
          path = "image path",
        ),
      ),

      duration = 3,
    ),
  ),
)

