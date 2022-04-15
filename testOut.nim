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
        audioOutCurve = squ,
        easing = "234",
        params = newEditlyTransitionParams(
          ("v1", %1),
          ("v2", %"test"),
          ("v4", %false),
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
  customOutputArgs = @[
    "arg1",
    "arg2",
    "arg4"
  ],
)

