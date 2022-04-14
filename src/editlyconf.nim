{.experimental: "dotOperators".}

## TODO: config generation at runtime using functions instead objects

import std/[
  json,
  macros,
  strutils # parseEnum
]

import editlyconf/types
  
func newEditlyConfig(
  outPath: string;
  clips: JsonNode;
  width = 640;
  height = 0;
  fps = 25;
  customOutputArgs = newSeq[string]();
  allowRemoteRequests = false;
  fast = false;
  defaults = newJObject()
): JsonNode = 
  result = %*{
    "outPath": outPath,
    "clips": clips,
    "width": width,
    "height": height,
    "fps": fps,
    "customOutputArgs": customOutputArgs,
    "allowRemoteRequests": allowRemoteRequests,
    "fast": fast,
    "defaults": defaults,
  }

func newEditlyClips(clips: varargs[tuple[
  layers: JsonNode;
  duration: int; ## optional
  transition: JsonNode
]]): JsonNode =
  result = newJArray()
  for clip in clips:
    result.add %*{
      "layers": clip.layers,
      "duration": clip.duration,
      "transition": clip.transition
    }

func newEditlyTransition(
  duration = 0.5;
  name = TransitionType.random;
  audioOutCurve = CurveType.tri;
  audioInCurve = CurveType.tri;
  easing = "";
  params: JsonNode
): JsonNode =
  result = %*{
    "duration": duration,
    "name": name,
    "audioOutCurve": audioOutCurve,
    "audioInCurve": audioInCurve,
    "easing": easing,
    "params": params
  }


func newEditlyTransitionParams(
  params: varargs[(string, JsonNode)]
): JsonNode =
  result = newJObject()
  for param in params:
    result{param[0]} = param[1]

func newEditlyLayer(
  kind: LayerKind = LayerKind.none;
  backgroundColor: string = "";
  charSpacing: int = 0;
  color: string = "";
  colors: array[2, string] = ["", ""];
  cutFrom: int = 0;
  cutTo: int = 0;
  duration: int = 0;
  fontPath: string = "";
  fontSize: int = 0;
  height: float = 0;
  left: float = 0;
  mixVolume: string = "";
  path: string = "";
  start: int = 0;
  text: string = "";
  textColor: string = "";
  top: float = 0;
  width: float = 0;
  zoomAmount: float = 0;
  zoomDirection: string = "";
  background: JsonNode = newJObject();
  originX: OriginX = OriginX.left;
  originY: OriginY = OriginY.top;
  position: JsonNode = newJObject();
  resizeMode: ResizeMode = ResizeMode.contain;
  fragmentPath: string = "";
  vertexPath: string = "";
  speed: float = 0
): JsonNode =
  result = newJObject()
  template setProp(name: untyped): untyped =
    block:
      var default: type `name`
      when default is JsonNode:
        debugEcho "name: " & asttostr name
        if default == newJArray() or default == newJObject():
          break
        debugEcho default
      else:
        if default == `name`:
          break
      result[astToStr name] = %`name`
  setProp kind
  setProp backgroundColor
  setProp charSpacing
  setProp color
  setProp colors
  setProp cutFrom
  setProp cutTo
  setProp duration
  setProp fontPath
  setProp fontSize
  setProp height
  setProp left
  setProp mixVolume
  setProp path
  setProp start
  setProp text
  setProp textColor
  setProp top
  setProp width
  setProp zoomAmount
  setProp zoomDirection
  setProp background
  setProp originY
  setProp originX
  setProp position
  setProp resizeMode
  setProp fragmentPath
  setProp vertexPath
  setProp speed
  

func newEditlyLayers(layers: varargs[JsonNode]): JsonNode =
  result = newJArray()
  for l in layers:
    debugecho l
    let kind = parseEnum[LayerKind](l["kind"].getStr)
    var layer = %*{
      "type": l{"kind"}
    }
    template setProp(name: untyped; required = false): untyped =
      const n = astToStr name
      let val = l{n}
      if val == newJnull():
        doAssert(false)
        if required:
          doAssert(false)
            # doAssert(Layer().`name` != val)
      else:
        layer{n} = val
    case kind:
    of video:
      setProp(path, required = true)
      setProp(resizeMode)
      setProp(cutFrom)
      setProp(cutFrom)
      setProp(cutTo)
      setProp(width)
      setProp(height)
      setProp(left)
      setProp(top)
      setProp(originX)
      setProp(originY)
      setProp(mixVolume)
    of audio, detachedAudio:
      setProp(path, required = true)
      setProp(cutFrom)
      setProp(cutFrom)
      setProp(mixVolume)
    of image:
      setProp(path, required = true)
      setProp(resizeMode)
      setProp(duration)
    of imageOverlay:
      setProp(path, required = true)
      setProp(position)
      setProp(width)
      setProp(height)
      setProp(zoomDirection)
      setProp(zoomAmount)
    of title:
      setProp(text, required = true)
      setProp(textColor)
      setProp(fontPath)
      setProp(position)
    of subtitle:
      setProp(text, required = true)
      setProp(textColor)
      setProp(fontPath)
      setProp(backgroundColor)
    of titleBackground:
      setProp(text, required = true)
      setProp(textColor)
      setProp(fontPath)
      setProp(background)
    of newsTitle:
      setProp(text, required = true)
      setProp(textColor)
      setProp(fontPath)
      setProp(backgroundColor)
      setProp(position)
    of slideInText:
      setProp(text, required = true)
      setProp(fontPath)
      setProp(fontSize)
      setProp(charSpacing)
      setProp(color)
      setProp(position)
    of LayerKind.fillColor:
      setProp(color)
    of pause:
      setProp(color)
    of LayerKind.radialGradient:
      setProp(colors)
    of LayerKind.linearGradient:
      setProp(colors)
    of rainbowColors:
      discard
    of gl:
      setProp(fragmentPath, required = true)
      setProp(vertexPath)
      setProp(speed)
    of editlyBanner:
      discard
    of LayerKind.none:
      doAssert false, "Provide the layer type"
    result.add layer
    debugecho layer

func newEditlyPosition(
  pos = Position.none;
  x = 0.0;
  y = 0.0;
  originX = OriginX.center;
  originY = OriginY.center
): JsonNode =
  if pos != none:
    result = %pos
  else:
    result = %*{
      "x": x,
      "y": y,
      "originX": originX,
      "originY": originY
    }

func newEditlyDefaults(
  duration = 4;
  layer = newJObject();
  layerType = newJObject();
  transition = newJObject()
): JsonNode =
  result = %*{
    "duration": duration,
    "layerType": layerType,
    "transition": transition
  }
  result["layer"] = %*layer


# func newEditly(): JsonNode =
#   result = %*{
#     "": 
#   }

when isMainModule:
  echo newEditlyLayer(
    kind = imageOverlay,
    position = newEditlyPosition(top),
    path = "dsadl;l;l;"
  )
  echo pretty newEditlyConfig(
    outPath = "out.mp4",
    clips = newEditlyClips(
      (
        layers: newEditlyLayers(
          newEditlyLayer(
            kind = imageOverlay,
            position = newEditlyPosition(top),
            path = "dsadl;l;l;"
          )
        ),
        duration: 3,
        transition: newEditlyTransition(
          duration = 0.5,
          name = random,
          audioOutCurve = tri,
          audioInCurve = tri,
          easing = "",
          params = newEditlyTransitionParams(
            ("test", %1)
          )
        )
      )
    ),
    defaults = newEditlyDefaults(
      duration = 4,
      layer = newEditlyLayer(
        path = "das"
      )
    )
  )
