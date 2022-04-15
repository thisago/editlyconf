## This module converts JSON Editly configs into nim function calls

from std/json import parseJson, `{}`, getStr, JsonNode, JsonNodeKind, items,
                      getBool, getFloat, getInt, hasKey, keys, `$`
from std/strformat import fmt
from std/strutils import repeat, multiReplace, join

const
  comma = ","
  clsParen = ")" & comma
  clsCurly = "}" & comma
  clsBrkt = "]" & comma

func indent*(s: string, count: Natural, padding: string = "  "): string =
  strutils.indent(s, count, padding) & "\l"

proc getProp(node: JsonNode; name: string): string =
  let n = node{name}
  if n.isNil: return
  result =
    case n.kind:
    of JBool:   $n.getBool
    of JFloat:  $n.getFloat
    of JInt:    $n.getInt
    of JString: "\"" & n.getStr & "\""
    of JObject: "[JSON Object]"
    of JArray:  "[JSON Array]"
    of JNull:   ""

proc addProp[T](
  res: var T;
  node: JsonNode;
  prop: string;
  indentLevel = 1;
  escape = "";
  process = proc(s: string): string = s
) =
  var val = node.getProp prop
  if val.len > 0:
    val = process val
    var r = prop
    if escape.len > 0:
      r = escape
    r.add " = "
    r.add val
    r.add comma
    res.add r.indent indentLevel

proc addTmp(
  res: var string;
  tmp: string
) =
  let
    test = tmp.multiReplace({
      "{": "",
      "}": "",
      "(": "",
      ")": "",
      "[": "",
      "]": "",
      "\l": "",
      " ": "",
      comma: "",
    })
  if test.len > 0:
    res.add tmp

proc fixLayerKind(s: string): string =
  result = s[1..^2]
  result = 
    case result:
    of "detached-audio": "detachedAudio"
    of "image-overlay": "imageOverlay"
    of "title-background": "titleBackground"
    of "news-title": "newsTitle"
    of "in-text": "inText"
    of "fill-color": "fillColor"
    of "radial-gradient": "radialGradient"
    of "linear-gradient": "linearGradient"
    of "rainbow-colors": "rainbowColors"
    else: result

proc fixCurveType(s: string): string =
  result = s[1..^2]

proc translateEditlyConf(conf: string): string =
  let node = parseJson conf
  result = "newEditlyConfig(".indent 0
  
  result.addProp(node, "outPath", indentLevel = 1)

  block clips:
    result.add "clips = newEditlyClips(".indent 1
    var tmp = ""
    for clip in node{"clips"}:
      tmp.add "newEditlyClip(".indent 2
      var clipProps: seq[string]
      block layers:
        var l = ""
        l.add "layers = newEditlyLayers(".indent 3
        for layer in clip{"layers"}:
          l.add "newEditlyLayer(".indent 4
          l.addProp(layer, "type", indentLevel = 5, escape = "kind", fixLayerKind)
          l.addProp(layer, "backgroundColor", indentLevel = 5)
          l.addProp(layer, "charSpacing", indentLevel = 5)
          l.addProp(layer, "color", indentLevel = 5)
          l.addProp(layer, "colors", indentLevel = 5)
          l.addProp(layer, "cutFrom", indentLevel = 5)
          l.addProp(layer, "cutTo", indentLevel = 5)
          l.addProp(layer, "duration", indentLevel = 5)
          l.addProp(layer, "fontPath", indentLevel = 5)
          l.addProp(layer, "fontSize", indentLevel = 5)
          l.addProp(layer, "height", indentLevel = 5)
          l.addProp(layer, "left", indentLevel = 5)
          l.addProp(layer, "mixVolume", indentLevel = 5)
          l.addProp(layer, "path", indentLevel = 5)
          l.addProp(layer, "start", indentLevel = 5)
          l.addProp(layer, "text", indentLevel = 5)
          l.addProp(layer, "textColor", indentLevel = 5)
          l.addProp(layer, "top", indentLevel = 5)
          l.addProp(layer, "width", indentLevel = 5)
          l.addProp(layer, "zoomAmount", indentLevel = 5)
          l.addProp(layer, "zoomDirection", indentLevel = 5)
          l.addProp(layer, "background", indentLevel = 5)
          l.addProp(layer, "originY", indentLevel = 5)
          l.addProp(layer, "originX", indentLevel = 5)
          l.addProp(layer, "position", indentLevel = 5)
          l.addProp(layer, "resizeMode", indentLevel = 5)
          l.addProp(layer, "fragmentPath", indentLevel = 5)
          l.addProp(layer, "vertexPath", indentLevel = 5)
          l.addProp(layer, "speed", indentLevel = 5)
          l.add clsParen.indent 4
        l.add clsParen.indent 3
        clipProps.add l
      block transition:
        if clip.hasKey "transition":
          let tr = clip{"transition"}
          var l = ""
          l.add "transition = newEditlyTransition(".indent 3
          l.addProp(tr, "duration", indentLevel = 4)
          l.addProp(tr, "audioInCurve", indentLevel = 4, process = fixCurveType)
          l.addProp(tr, "audioOutCurve", indentLevel = 4, process = fixCurveType)
          l.addProp(tr, "easing", indentLevel = 4)
          block params:
            if tr.hasKey "params":
              l.add "params = newEditlyTransitionParams(".indent 4
              let trParams = tr{"params"}
              for key in trParams.keys:
                l.add fmt"""("{key}", %{$trParams.getProp key}),""".indent 5
              l.add clsParen.indent 4
              
          l.add clsParen.indent 3
          clipProps.add l
          
      clipProps.addProp(clip, "duration", indentLevel = 3)
      tmp.add clipProps.join "\l"
      tmp.add clsParen.indent 2
      if clipProps.len > 0:
        result.addTmp tmp
      tmp = ""
    result.add clsParen.indent 1

  result.addProp(node, "width", indentLevel = 1)
  result.addProp(node, "height", indentLevel = 1)
  result.addProp(node, "fps", indentLevel = 1)

  block customOutputArgs:
    if node.hasKey "customOutputArgs":
      result.add "customOutputArgs = @[".indent 1
      var list: seq[string]
      for arg in node{"customOutputArgs"}:
        list.add "\"" & arg.getStr & "\""
      result.add list.join(",\l").indent 2
      result.add clsBrkt.indent 1

  result.addProp(node, "allowRemoteRequests", indentLevel = 1)
  result.addProp(node, "fast", indentLevel = 1)

  block defaults:
    if node.hasKey "defaults":
      


  result.add ")".indent 0

when isMainModule:
  echo translateEditlyConf """{
  "outPath": "./out.mp4",
  "defaults": {
    "transition": {
      "name": "random"
    },
  },
  "clips": [
    {
      "duration": 3,
      "layers": [
        {
          "type": "image",
          "path": "image path"
        }
      ],
      "transition": {
        "duration": 1,
        "audioInCurve": "squ",
        "audioOutCurve": "squ",
        "easing": "234",
        "params": {
          "v1": 1,
          "v2": "test",
          "v4": false
        }
      }
    },
    {
      "duration": 3,
      "layers": [
        {
          "type": "image",
          "path": "image path"
        }
      ]
    },
    {
      "duration": 3,
      "layers": [
        {
          "type": "image",
          "path": "image path"
        }
      ]
    },
    {
      "duration": 3,
      "layers": [
        {
          "type": "image",
          "path": "image path"
        }
      ]
    },
    {
      "duration": 3,
      "layers": [
        {
          "type": "image",
          "path": "image path"
        }
      ]
    },
    {
      "duration": 3,
      "layers": [
        {
          "type": "image",
          "path": "image path"
        }
      ]
    },
    {
      "duration": 3,
      "layers": [
        {
          "type": "image",
          "path": "image path"
        }
      ]
    },
    {
      "duration": 3,
      "layers": [
        {
          "type": "image",
          "path": "image path"
        }
      ]
    },
    {
      "duration": 3,
      "layers": [
        {
          "type": "image",
          "path": "image path"
        }
      ]
    },
  ],
  "customOutputArgs": [
    "arg1",
    "arg2",
    "arg4",
  ]
}"""
