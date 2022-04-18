## TODO: config generation at runtime using functions instead objects

# import std/[
#   json,
#   macros,
#   strutils # parseEnum
# ]

from std/json import JsonNode, newJObject, newJArray, `%*`, `%`, `[]=`, add,
                      `[]`, getStr, `{}`, JArray, len, keys, JObject
from std/strutils import parseEnum
from std/sequtils import toSeq
import ./types
  
template add2Res(name, default: untyped; key = "") =
    block:
      when `name` is JsonNode:
        # if `name` == newJArray() or `name` == newJObject():
        if `name`.kind == JArray and `name`.len == 0: break
        if `name`.kind == JObject and toSeq(`name`.keys).len == 0: break
      else:
        if default == `name`:
          break
      let keyName = if key.len > 0: key else: astToStr name
      result[keyName] = %`name`
template add2Res(name: untyped; key = "") =
  var default {.used.}: typeof `name`
  add2Res(name, default, key)

func newEditlyConfig*(
  outPath: string;
  clips = newJArray();
  width = 640;
  height = 0;
  fps = 25;
  customOutputArgs = newSeq[string]();
  allowRemoteRequests = false;
  fast = false;
  defaults = newJObject();
  audioTracks = newJArray()
): JsonNode = 
  result = %*{
    "outPath": outPath,
    "clips": clips
  }
  add2Res width, 640
  add2Res height
  add2Res fps, 25
  add2Res customOutputArgs
  add2Res allowRemoteRequests
  add2Res fast
  add2Res defaults
  add2Res audioTracks

func newEditlyClips*(clips: varargs[JsonNode]): JsonNode =
  result = newJArray()
  for clip in clips:
    result.add clip

func newEditlyClip*(
  layers: JsonNode;
  duration = 4;
  transition = newJObject()
): JsonNode =
  result = %*{
    "layers": layers,
  }
  add2Res duration
  add2Res transition

func newEditlyTransition*(
  duration = 0.5;
  name = TransitionType.none;
  audioOutCurve = CurveType.none;
  audioInCurve = CurveType.none;
  easing = "";
  params = newJObject()
): JsonNode =
  result = newJObject()
  add2Res duration, 0.5
  add2Res name
  add2Res audioOutCurve
  add2Res audioInCurve
  add2Res easing
  add2Res params


func newEditlyTransitionParams*(
  params: varargs[(string, JsonNode)]
): JsonNode =
  result = newJObject()
  for param in params:
    result[param[0]] = param[1]

func newEditlyLayer*(
  kind: LayerKind = LayerKind.none;
  backgroundColor: string = "";
  charSpacing: int = 0;
  color: string = "";
  colors: array[2, string] = ["", ""];
  cutFrom: float = 0;
  cutTo: float = 0;
  duration: int = 0;
  fontPath: string = "";
  fontSize: int = 0;
  height: float = 0;
  left: float = 0;
  mixVolume: float = 0.0;
  path: string = "";
  start: int = 0;
  text: string = "";
  textColor: string = "";
  top: float = 0;
  width: float = 0;
  zoomAmount: float = 0;
  zoomDirection: string = "";
  background: JsonNode = newJObject();
  originX: OriginX = OriginX.none;
  originY: OriginY = OriginY.none;
  position: JsonNode = newJObject();
  resizeMode: ResizeMode = ResizeMode.none;
  fragmentPath: string = "";
  vertexPath: string = "";
  speed: float = 0
): JsonNode =
  result = newJObject()
  add2Res kind, key = "type"
  add2Res backgroundColor
  add2Res charSpacing
  add2Res color
  add2Res colors
  add2Res cutFrom
  add2Res cutTo
  add2Res duration
  add2Res fontPath
  add2Res fontSize
  add2Res height
  add2Res left
  add2Res mixVolume
  add2Res path
  add2Res start
  add2Res text
  add2Res textColor
  add2Res top
  add2Res width
  add2Res zoomAmount
  add2Res zoomDirection
  add2Res background
  add2Res originY
  add2Res originX
  add2Res position
  add2Res resizeMode
  add2Res fragmentPath
  add2Res vertexPath
  add2Res speed


func newEditlyLayers*(layers: varargs[JsonNode]): JsonNode =
  result = newJArray()
  for l in layers:
    let kind = parseEnum[LayerKind](l["kind"].getStr)
    var layer = %*{
      "type": l{"kind"}
    }
    template setProp(name: untyped; required = false): untyped =
      const n = astToStr name
      let val = l{n}
      if val.isNil:
          doAssert not required
      else:
        layer[n] = val
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

func newEditlyPosition*(
  pos = Position.none;
  x = 0.0;
  y = 0.0;
  originX = OriginX.center;
  originY = OriginY.center
): JsonNode =
  if pos != none:
    result = %pos
  else:
    result = newJObject()
    add2Res x
    add2Res y
    add2Res originX
    add2Res originY

func newEditlyDefaults*(
  duration = 4;
  layer = newJObject();
  layerType = newJObject();
  transition = newJObject()
): JsonNode =
  result = newJObject()
  add2Res duration, 4
  add2Res layerType
  add2Res transition
  add2Res layer

func newEditlyAudioTracks*(tracks: varargs[JsonNode]): JsonNode =
  result = newJArray()
  for track in tracks:
    result.add track

func newEditlyAudioTrack*(
  path: string;
  mixVolume = "1";
  cutFrom = 0;
  cutTo = 0;
  start = 0
): JsonNode =
  result = %*{
    "path": path,
  }
  add2Res mixVolume, "1"
  add2Res cutFrom
  add2Res cutTo
  add2Res start

when isMainModule:
  from std/json import pretty
  echo pretty newEditlyConfig(
    outPath = "out.mp4",
    clips = newEditlyClips(
      newEditlyClip(
        layers = newEditlyLayers(
        )
      ),
      newEditlyClip(
        layers = newEditlyLayers(
          newEditlyLayer(
            kind = imageOverlay,
            position = newEditlyPosition(top),
            path = "dsadl;l;l;"
          )
        ),
        duration = 3,
        transition = newEditlyTransition(
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
    ),
    audioTracks = newEditlyAudioTracks(
      newEditlyAudioTrack(
        "a.mp3"
      ),
      newEditlyAudioTrack(
        "b.mp3",
      )
    ),
    customOutputArgs = @["da", "asd"]
  )
