import std/json, editlyconf
writeFile "out.json", pretty newEditlyConfig(
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
  defaults = newEditlyDefaults(
    layer = newEditlyLayer(
      fontPath = "dasd",
      top = 24,
    ),
    layerType = %*{
      "fontPath": "dasd",
      "top": 24,
    },
    transition = newEditlyTransition(
      name = random,
    ),
  ),
)
