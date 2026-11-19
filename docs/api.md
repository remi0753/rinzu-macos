# rinzu.macos API reference

Generated from checked public exports and captured source comments.

Language: `rinzu-0.5` · target: `aarch64-apple-darwin` · semantics: `rinzu-language-0.5-r85`.

## rinzu.macos.Batch2D

class · [source](../src/macos.rinzu#L3268).

```rinzu
class Batch2D
```

Bounded, reusable quad batch. Coordinates and clip use target pixels, top-left.
Reset only after the command using its vertex buffer has physically settled.

### field vertices

[source](../src/macos.rinzu#L3269).

```rinzu
const vertices: Buffer
```

### field rgba

[source](../src/macos.rinzu#L3270).

```rinzu
const rgba: RenderPipeline
```

### field bgra

[source](../src/macos.rinzu#L3271).

```rinzu
const bgra: RenderPipeline
```

### field nearest

[source](../src/macos.rinzu#L3272).

```rinzu
const nearest: Sampler
```

### field linear

[source](../src/macos.rinzu#L3273).

```rinzu
const linear: Sampler
```

### field white

[source](../src/macos.rinzu#L3274).

```rinzu
const white: Texture
```

### field command

[source](../src/macos.rinzu#L3275).

```rinzu
const command: Command
```

### field capacity

[source](../src/macos.rinzu#L3276).

```rinzu
const capacity: Int
```

### field width

[source](../src/macos.rinzu#L3277).

```rinzu
width: Int
```

### field height

[source](../src/macos.rinzu#L3278).

```rinzu
height: Int
```

### field count

[source](../src/macos.rinzu#L3279).

```rinzu
count: Int
```

### field draws

[source](../src/macos.rinzu#L3280).

```rinzu
draws: List<BatchDraw2D>
```

### field transform

[source](../src/macos.rinzu#L3281).

```rinzu
transform: Transform2D
```

### field clip

[source](../src/macos.rinzu#L3282).

```rinzu
clip: Scissor
```

### field filter

[source](../src/macos.rinzu#L3283).

```rinzu
filter: Int
```

### field closed

[source](../src/macos.rinzu#L3284).

```rinzu
closed: Bool
```

### field rendering

[source](../src/macos.rinzu#L3285).

```rinzu
rendering: Bool
```

## rinzu.macos.Batch2D.destroy

Checked type: `fn(Batch2D)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3536).

```rinzu
fn destroy(self: Batch2D)
```

## rinzu.macos.Batch2D.drawCallCount

Checked type: `fn(Batch2D)->Int`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L3427).

```rinzu
fn drawCallCount(self: Batch2D) -> Int
```

## rinzu.macos.Batch2D.encode

Checked type: `fn(Batch2D,Command,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3432).

```rinzu
fn encode(self: Batch2D, command: Command, format: Int) -> Int
```

Encode into an already begun pass. On Error the caller must abandon it.

## rinzu.macos.Batch2D.fillRect

Checked type: `fn(Batch2D,Rect,Color)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3344).

```rinzu
fn fillRect(self: Batch2D, destination: Rect, color: Color)
```

## rinzu.macos.Batch2D.image

Checked type: `fn(Batch2D,Texture,Rect,Color)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3362).

```rinzu
fn image(self: Batch2D, texture: Texture, destination: Rect, tint: Color)
```

## rinzu.macos.Batch2D.imageRegion

Checked type: `fn(Batch2D,Texture,Rect,Rect,Color)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3367).

```rinzu
fn imageRegion(self: Batch2D, texture: Texture, destination: Rect, uv: Rect, tint: Color)
```

Normalized UVs, with row zero at the top. Texture pixels must be premultiplied.

## rinzu.macos.Batch2D.render

Checked type: `async(Batch2D,View,Color)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3469).

```rinzu
async fn render(self: Batch2D, surface: View, clear: Color) -> Int
```

Own a complete frame, including abandon / physical drain on Error or cancel.

## rinzu.macos.Batch2D.renderTexture

Checked type: `async(Batch2D,Texture,Color)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3502).

```rinzu
async fn renderTexture(self: Batch2D, texture: Texture, clear: Color) -> Int
```

## rinzu.macos.Batch2D.reset

Checked type: `fn(Batch2D,Int,Int)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3287).

```rinzu
fn reset(self: Batch2D, width: Int, height: Int)
```

## rinzu.macos.Batch2D.setClip

Checked type: `fn(Batch2D,Scissor)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3315).

```rinzu
fn setClip(self: Batch2D, clip: Scissor)
```

## rinzu.macos.Batch2D.setFilter

Checked type: `fn(Batch2D,Int)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3333).

```rinzu
fn setFilter(self: Batch2D, filter: Int)
```

## rinzu.macos.Batch2D.setTransform

Checked type: `fn(Batch2D,Transform2D)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3307).

```rinzu
fn setTransform(self: Batch2D, transform: Transform2D)
```

## rinzu.macos.Batch2D.text

Checked type: `fn(Batch2D,Text2D,Float,Float,Color)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3349).

```rinzu
fn text(self: Batch2D, text: Text2D, x: Float, y: Float, tint: Color)
```

Coordinates use the current batch transform. TextMetrics uses font points.

## rinzu.macos.BatchDraw2D

class · [source](../src/macos.rinzu#L3256).

```rinzu
class BatchDraw2D
```

A contiguous draw span. Constructed by Batch2D; do not mutate batch storage.

### field texture

[source](../src/macos.rinzu#L3257).

```rinzu
const texture: Texture
```

### field textureId

[source](../src/macos.rinzu#L3258).

```rinzu
const textureId: Int
```

### field sampler

[source](../src/macos.rinzu#L3259).

```rinzu
const sampler: Sampler
```

### field filter

[source](../src/macos.rinzu#L3260).

```rinzu
const filter: Int
```

### field clip

[source](../src/macos.rinzu#L3261).

```rinzu
const clip: Scissor
```

### field first

[source](../src/macos.rinzu#L3262).

```rinzu
const first: Int
```

### field count

[source](../src/macos.rinzu#L3263).

```rinzu
count: Int
```

## rinzu.macos.Buffer

class · [source](../src/macos.rinzu#L12).

```rinzu
class Buffer
```

### field handle

[source](../src/macos.rinzu#L13).

```rinzu
const handle: BufferHandle
```

## rinzu.macos.Buffer.destroy

Checked type: `fn(Buffer)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L27).

```rinzu
fn destroy(self: Buffer) -> Int
```

## rinzu.macos.Buffer.read

Checked type: `fn(Buffer,Int,Int)->ByteArray`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L22).

```rinzu
fn read(self: Buffer, offset: Int, length: Int) -> ByteArray
```

## rinzu.macos.Buffer.write

Checked type: `fn(Buffer,Int,ByteArray)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L15).

```rinzu
fn write(self: Buffer, offset: Int, bytes: ByteArray) -> Int
```

## rinzu.macos.Buffer.writeQuad2D

Checked type: `fn(Buffer,Int,Quad2D)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L35).

```rinzu
fn writeQuad2D(self: Buffer, index: Int, quad: Quad2D) -> Int
```

## rinzu.macos.Buffer.writeVertex2D

Checked type: `fn(Buffer,Int,Vertex2D)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L31).

```rinzu
fn writeVertex2D(self: Buffer, index: Int, vertex: Vertex2D) -> Int
```

## rinzu.macos.BufferHandle

Checked type: `BufferHandle`.

opaque · [source](../src/macos.rinzu#L1014).

```rinzu
opaque BufferHandle;
```

## rinzu.macos.Button

class · [source](../src/macos.rinzu#L2631).

```rinzu
class Button
```

### field view

[source](../src/macos.rinzu#L2632).

```rinzu
const view: View
```

## rinzu.macos.Button.destroy

Checked type: `fn(Button)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2638).

```rinzu
fn destroy(self: Button) -> Int
```

## rinzu.macos.Button.identity

Checked type: `fn(Button)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2634).

```rinzu
fn identity(self: Button) -> Int
```

## rinzu.macos.Button.setEnabled

Checked type: `fn(Button,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2642).

```rinzu
fn setEnabled(self: Button, enabled: Bool) -> Int
```

## rinzu.macos.Button.setText

Checked type: `fn(Button,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2650).

```rinzu
fn setText(self: Button, value: String) -> Int
```

## rinzu.macos.Button.text

Checked type: `fn(Button)->String`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2646).

```rinzu
fn text(self: Button) -> String
```

## rinzu.macos.Canvas2D

class · [source](../src/macos.rinzu#L3619).

```rinzu
class Canvas2D
```

### field view

[source](../src/macos.rinzu#L3620).

```rinzu
const view: View
```

### field clock

[source](../src/macos.rinzu#L3621).

```rinzu
const clock: FrameClock
```

### field batch

[source](../src/macos.rinzu#L3622).

```rinzu
const batch: Batch2D
```

### field clear

[source](../src/macos.rinzu#L3623).

```rinzu
clear: Color
```

### field frames

[source](../src/macos.rinzu#L3624).

```rinzu
frames: Int
```

### field drawing

[source](../src/macos.rinzu#L3625).

```rinzu
drawing: Bool
```

### field stopped

[source](../src/macos.rinzu#L3626).

```rinzu
stopped: Bool
```

### field disposed

[source](../src/macos.rinzu#L3627).

```rinzu
disposed: Bool
```

## rinzu.macos.Canvas2D.invalidate

Checked type: `fn(Canvas2D)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3629).

```rinzu
fn invalidate(self: Canvas2D) -> Int
```

## rinzu.macos.Canvas2D.setAnimating

Checked type: `fn(Canvas2D,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3636).

```rinzu
fn setAnimating(self: Canvas2D, enabled: Bool) -> Int
```

## rinzu.macos.Canvas2D.setClear

Checked type: `fn(Canvas2D,Color)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3643).

```rinzu
fn setClear(self: Canvas2D, color: Color)
```

## rinzu.macos.Canvas2D.stop

Checked type: `fn(Canvas2D)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3648).

```rinzu
fn stop(self: Canvas2D)
```

## rinzu.macos.Checkbox

class · [source](../src/macos.rinzu#L2657).

```rinzu
class Checkbox
```

### field view

[source](../src/macos.rinzu#L2658).

```rinzu
const view: View
```

## rinzu.macos.Checkbox.checked

Checked type: `fn(Checkbox)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2680).

```rinzu
fn checked(self: Checkbox) -> Bool
```

## rinzu.macos.Checkbox.destroy

Checked type: `fn(Checkbox)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2664).

```rinzu
fn destroy(self: Checkbox) -> Int
```

## rinzu.macos.Checkbox.identity

Checked type: `fn(Checkbox)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2660).

```rinzu
fn identity(self: Checkbox) -> Int
```

## rinzu.macos.Checkbox.setChecked

Checked type: `fn(Checkbox,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2685).

```rinzu
fn setChecked(self: Checkbox, value: Bool) -> Int
```

## rinzu.macos.Checkbox.setEnabled

Checked type: `fn(Checkbox,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2668).

```rinzu
fn setEnabled(self: Checkbox, enabled: Bool) -> Int
```

## rinzu.macos.Checkbox.setText

Checked type: `fn(Checkbox,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2676).

```rinzu
fn setText(self: Checkbox, value: String) -> Int
```

## rinzu.macos.Checkbox.text

Checked type: `fn(Checkbox)->String`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2672).

```rinzu
fn text(self: Checkbox) -> String
```

## rinzu.macos.Color

Checked type: `Color`.

native-record · [source](../src/macos.rinzu#L1045).

```rinzu
record Color
```

### field red

[source](../src/macos.rinzu#L1046).

```rinzu
red: Float
```

### field green

[source](../src/macos.rinzu#L1047).

```rinzu
green: Float
```

### field blue

[source](../src/macos.rinzu#L1048).

```rinzu
blue: Float
```

### field alpha

[source](../src/macos.rinzu#L1049).

```rinzu
alpha: Float
```

## rinzu.macos.Command

class · [source](../src/macos.rinzu#L60).

```rinzu
class Command
```

### field handle

[source](../src/macos.rinzu#L61).

```rinzu
const handle: CommandHandle
```

## rinzu.macos.Command.abandon

Checked type: `fn(Command)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L117).

```rinzu
fn abandon(self: Command) -> Int
```

## rinzu.macos.Command.beginCompute

Checked type: `fn(Command,ComputePipeline)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L63).

```rinzu
fn beginCompute(self: Command, pipeline: ComputePipeline) -> Int
```

## rinzu.macos.Command.beginRender

Checked type: `fn(Command,View,Color)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L67).

```rinzu
fn beginRender(self: Command, view: View, clear: Color) -> Int
```

## rinzu.macos.Command.beginRenderMatching

Checked type: `fn(Command,View,Color,Int,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L73).

```rinzu
fn beginRenderMatching(self: Command, view: View, clear: Color, width: Int, height: Int) -> Int
```

Admit only a drawable matching a previously captured pixel extent.
A resize mismatch is retryable (-7810); the command remains idle and unleased.

## rinzu.macos.Command.beginRenderTexture

Checked type: `fn(Command,Texture,Color)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L129).

```rinzu
fn beginRenderTexture(self: Command, texture: Texture, clear: Color) -> Int
```

## rinzu.macos.Command.commit

Checked type: `fn(Command)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L113).

```rinzu
fn commit(self: Command) -> Int
```

## rinzu.macos.Command.destroy

Checked type: `fn(Command)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L125).

```rinzu
fn destroy(self: Command) -> Int
```

## rinzu.macos.Command.dispatch

Checked type: `fn(Command,Int,Int,Int,Int,Int,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L105).

```rinzu
fn dispatch(self: Command, x: Int, y: Int, z: Int, tx: Int, ty: Int, tz: Int) -> Int
```

## rinzu.macos.Command.drawTriangles

Checked type: `fn(Command,Int,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L109).

```rinzu
fn drawTriangles(self: Command, start: Int, count: Int) -> Int
```

## rinzu.macos.Command.setComputeBuffer

Checked type: `fn(Command,Int,Buffer,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L84).

```rinzu
fn setComputeBuffer(self: Command, index: Int, buffer: Buffer, offset: Int) -> Int
```

## rinzu.macos.Command.setComputeSampler

Checked type: `fn(Command,Int,Sampler)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L157).

```rinzu
fn setComputeSampler(self: Command, index: Int, sampler: Sampler) -> Int
```

## rinzu.macos.Command.setComputeTexture

Checked type: `fn(Command,Int,Texture)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L142).

```rinzu
fn setComputeTexture(self: Command, index: Int, texture: Texture) -> Int
```

## rinzu.macos.Command.setFragmentBuffer

Checked type: `fn(Command,Int,Buffer,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L98).

```rinzu
fn setFragmentBuffer(self: Command, index: Int, buffer: Buffer, offset: Int) -> Int
```

## rinzu.macos.Command.setFragmentSampler

Checked type: `fn(Command,Int,Sampler)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L165).

```rinzu
fn setFragmentSampler(self: Command, index: Int, sampler: Sampler) -> Int
```

## rinzu.macos.Command.setFragmentTexture

Checked type: `fn(Command,Int,Texture)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L150).

```rinzu
fn setFragmentTexture(self: Command, index: Int, texture: Texture) -> Int
```

## rinzu.macos.Command.setRenderPipeline

Checked type: `fn(Command,RenderPipeline)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L80).

```rinzu
fn setRenderPipeline(self: Command, pipeline: RenderPipeline) -> Int
```

## rinzu.macos.Command.setScissor

Checked type: `fn(Command,Scissor)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L138).

```rinzu
fn setScissor(self: Command, scissor: Scissor) -> Int
```

## rinzu.macos.Command.setVertexBuffer

Checked type: `fn(Command,Int,Buffer,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L91).

```rinzu
fn setVertexBuffer(self: Command, index: Int, buffer: Buffer, offset: Int) -> Int
```

## rinzu.macos.Command.setVertexSampler

Checked type: `fn(Command,Int,Sampler)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L161).

```rinzu
fn setVertexSampler(self: Command, index: Int, sampler: Sampler) -> Int
```

## rinzu.macos.Command.setVertexTexture

Checked type: `fn(Command,Int,Texture)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L146).

```rinzu
fn setVertexTexture(self: Command, index: Int, texture: Texture) -> Int
```

## rinzu.macos.Command.setViewport

Checked type: `fn(Command,Rect)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L134).

```rinzu
fn setViewport(self: Command, viewport: Rect) -> Int
```

Render state uses pixels with top-left origin, independently of AppKit points.

## rinzu.macos.Command.wait

Checked type: `async(Command)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L121).

```rinzu
async fn wait(self: Command) -> Int
```

## rinzu.macos.CommandHandle

Checked type: `CommandHandle`.

opaque · [source](../src/macos.rinzu#L1032).

```rinzu
opaque CommandHandle;
```

## rinzu.macos.ComputePipeline

class · [source](../src/macos.rinzu#L173).

```rinzu
class ComputePipeline
```

### field handle

[source](../src/macos.rinzu#L174).

```rinzu
const handle: ComputePipelineHandle
```

## rinzu.macos.ComputePipeline.destroy

Checked type: `fn(ComputePipeline)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L176).

```rinzu
fn destroy(self: ComputePipeline) -> Int
```

## rinzu.macos.ComputePipelineHandle

Checked type: `ComputePipelineHandle`.

opaque · [source](../src/macos.rinzu#L1028).

```rinzu
opaque ComputePipelineHandle;
```

## rinzu.macos.DataColumn

class · [source](../src/macos.rinzu#L3979).

```rinzu
class DataColumn
```

### field title

[source](../src/macos.rinzu#L3980).

```rinzu
const title: String
```

### field width

[source](../src/macos.rinzu#L3981).

```rinzu
const width: Float
```

### field sortable

[source](../src/macos.rinzu#L3982).

```rinzu
const sortable: Bool
```

## rinzu.macos.DataRow

class · [source](../src/macos.rinzu#L3986).

```rinzu
class DataRow
```

IDs are positive and unique. A tree parent must precede its children; zero is a root.

### field id

[source](../src/macos.rinzu#L3987).

```rinzu
const id: Int
```

### field parent

[source](../src/macos.rinzu#L3988).

```rinzu
const parent: Int
```

### field cells

[source](../src/macos.rinzu#L3989).

```rinzu
const cells: List<String>
```

## rinzu.macos.DataState

Checked type: `DataState`.

native-record · [source](../src/macos.rinzu#L3918).

```rinzu
record DataState
```

### field rows

[source](../src/macos.rinzu#L3919).

```rinzu
rows: Int
```

### field visibleRows

[source](../src/macos.rinzu#L3920).

```rinzu
visibleRows: Int
```

### field cellViews

[source](../src/macos.rinzu#L3921).

```rinzu
cellViews: Int
```

### field bytes

[source](../src/macos.rinzu#L3922).

```rinzu
bytes: Int
```

### field revision

[source](../src/macos.rinzu#L3923).

```rinzu
revision: Int
```

### field selectedId

[source](../src/macos.rinzu#L3924).

```rinzu
selectedId: Int
```

### field selectedRow

[source](../src/macos.rinzu#L3925).

```rinzu
selectedRow: Int
```

### field firstVisible

[source](../src/macos.rinzu#L3926).

```rinzu
firstVisible: Int
```

### field lastVisible

[source](../src/macos.rinzu#L3927).

```rinzu
lastVisible: Int
```

### field pendingRows

[source](../src/macos.rinzu#L3928).

```rinzu
pendingRows: Int
```

## rinzu.macos.DataView

class · [source](../src/macos.rinzu#L3993).

```rinzu
class DataView
```

Shared List/Table/Tree interface. Model and AppKit datasource contain native copies only.

### field view

[source](../src/macos.rinzu#L3994).

```rinzu
const view: View
```

### field columns

[source](../src/macos.rinzu#L3995).

```rinzu
const columns: Int
```

### field control

[source](../src/macos.rinzu#L3996).

```rinzu
const control: UiControl
```

## rinzu.macos.DataView.accepts

Checked type: `fn(DataView,UiEvent)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4023).

```rinzu
fn accepts(self: DataView, event: UiEvent) -> Bool
```

## rinzu.macos.DataView.cell

Checked type: `fn(DataView,Int,Int)->String`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4051).

```rinzu
fn cell(self: DataView, id: Int, column: Int) -> String
```

## rinzu.macos.DataView.destroy

Checked type: `fn(DataView)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4002).

```rinzu
fn destroy(self: DataView) -> Int
```

## rinzu.macos.DataView.generateRows

Checked type: `async(DataView,Int,$rinzu_closure_530a103bc12515a3)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4065).

```rinzu
async fn generateRows(self: DataView, count: Int, make: fn (Int) -> DataRow)
```

Build offscreen, yield every 256 rows, and publish one complete model.

## rinzu.macos.DataView.identity

Checked type: `fn(DataView)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3998).

```rinzu
fn identity(self: DataView) -> Int
```

## rinzu.macos.DataView.isExpanded

Checked type: `fn(DataView,Int)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4043).

```rinzu
fn isExpanded(self: DataView, id: Int) -> Bool
```

## rinzu.macos.DataView.scrollTo

Checked type: `fn(DataView,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4035).

```rinzu
fn scrollTo(self: DataView, id: Int) -> Int
```

## rinzu.macos.DataView.select

Checked type: `fn(DataView,Int,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4031).

```rinzu
fn select(self: DataView, id: Int, reveal: Bool) -> Int
```

## rinzu.macos.DataView.setExpanded

Checked type: `fn(DataView,Int,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4039).

```rinzu
fn setExpanded(self: DataView, id: Int, expanded: Bool) -> Int
```

## rinzu.macos.DataView.setRows

Checked type: `async(DataView,List<DataRow>)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4096).

```rinzu
async fn setRows(self: DataView, rows: List<DataRow>)
```

## rinzu.macos.DataView.sort

Checked type: `fn(DataView,Int,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4047).

```rinzu
fn sort(self: DataView, column: Int, ascending: Bool) -> Int
```

## rinzu.macos.DataView.state

Checked type: `fn(DataView)->DataState`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L4006).

```rinzu
fn state(self: DataView) -> DataState
```

## rinzu.macos.Device

class · [source](../src/macos.rinzu#L181).

```rinzu
class Device
```

### field handle

[source](../src/macos.rinzu#L182).

```rinzu
const handle: DeviceHandle
```

## rinzu.macos.Device.allocateBuffer

Checked type: `fn(Device,Int)->Buffer`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L190).

```rinzu
fn allocateBuffer(self: Device, length: Int) -> Buffer
```

## rinzu.macos.Device.batch2D

Checked type: `fn(Device,Int)->Batch2D`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L255).

```rinzu
fn batch2D(self: Device, capacity: Int) -> Batch2D
```

## rinzu.macos.Device.buffer

Checked type: `fn(Device,ByteArray)->Buffer`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L184).

```rinzu
fn buffer(self: Device, bytes: ByteArray) -> Buffer
```

## rinzu.macos.Device.command

Checked type: `fn(Device)->Command`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L217).

```rinzu
fn command(self: Device) -> Command
```

Allocate a reusable command handle, normally once per in-flight frame slot.

## rinzu.macos.Device.destroy

Checked type: `fn(Device)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L221).

```rinzu
fn destroy(self: Device) -> Int
```

## rinzu.macos.Device.imageTexture

Checked type: `fn(Device,ByteArray)->Texture`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L235).

```rinzu
fn imageTexture(self: Device, encoded: ByteArray) -> Texture
```

Decode frame zero, normalize EXIF orientation and premultiplied sRGB RGBA8.
Encoded input <=64 MiB, dimensions <=8192, decoded pixels <=256 MiB.

## rinzu.macos.Device.library

Checked type: `fn(Device,String)->Library`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L194).

```rinzu
fn library(self: Device, source: String) -> Library
```

## rinzu.macos.Device.loadImageTexture

Checked type: `async(Device,String)->Texture`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L305).

```rinzu
async fn loadImageTexture(self: Device, path: String) -> Texture
```

Stream the encoded file with a 64 MiB limit, then decode on Main.
Decode/upload is synchronous; cooperative async decode is a later extension.

## rinzu.macos.Device.loadLibrary

Checked type: `fn(Device,String)->Library`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L203).

```rinzu
fn loadLibrary(self: Device, path: String) -> Library
```

## rinzu.macos.Device.rasterText

Checked type: `fn(Device,TextLayout,Float)->Texture`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L310).

```rinzu
fn rasterText(self: Device, layout: TextLayout, scale: Float) -> Texture
```

## rinzu.macos.Device.sampler

Checked type: `fn(Device,Int,Int)->Sampler`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L243).

```rinzu
fn sampler(self: Device, filter: Int, address: Int) -> Sampler
```

## rinzu.macos.Device.surface

Checked type: `fn(Device,Rect)->View`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L212).

```rinzu
fn surface(self: Device, rect: Rect) -> View
```

## rinzu.macos.Device.text2D

Checked type: `fn(Device,Font,String,Float,Int,Float)->Text2D`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L316).

```rinzu
fn text2D(self: Device, font: Font, text: String, width: Float, alignment: Int, scale: Float) -> Text2D
```

## rinzu.macos.Device.texture2D

Checked type: `fn(Device,Int,Int,Int,Int)->Texture`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L227).

```rinzu
fn texture2D(self: Device, width: Int, height: Int, format: Int, usage: Int) -> Texture
```

Single-level RGBA8, BGRA8, R8 or Alpha8 unorm storage. Usage combines distinct flags.
Alpha8 samples coverage as (a,a,a,a); it supports sampled/storage usage, not render targets.

## rinzu.macos.Device.vertexBuffer2D

Checked type: `fn(Device,Int)->Buffer`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L248).

```rinzu
fn vertexBuffer2D(self: Device, capacity: Int) -> Buffer
```

Allocate packed float32 x,y,u,v,r,g,b,a vertices (32 bytes each).

## rinzu.macos.DeviceHandle

Checked type: `DeviceHandle`.

opaque · [source](../src/macos.rinzu#L1012).

```rinzu
opaque DeviceHandle;
```

## rinzu.macos.Document

class · [source](../src/document.rinzu#L117).

```rinzu
class Document
```

Source document state. Native input updates this model without echoing setText.
Public mutations finish synchronously under cancellation masking.

### field undo

[source](../src/document.rinzu#L118).

```rinzu
const undo: DocumentHistory
```

### field redo

[source](../src/document.rinzu#L119).

```rinzu
const redo: DocumentHistory
```

### field text

[source](../src/document.rinzu#L120).

```rinzu
text: String
```

### field start

[source](../src/document.rinzu#L121).

```rinzu
start: Int
```

### field end

[source](../src/document.rinzu#L122).

```rinzu
end: Int
```

### field version

[source](../src/document.rinzu#L123).

```rinzu
version: Int
```

### field savedVersion

[source](../src/document.rinzu#L124).

```rinzu
savedVersion: Int
```

### field accepting

[source](../src/document.rinzu#L125).

```rinzu
accepting: Bool
```

### field edits

[source](../src/document.rinzu#L126).

```rinzu
edits: Int
```

## rinzu.macos.Document.accepts

Checked type: `fn(document::Document,document::DocumentSnapshot)->Bool`.

Error contract: `nothrow` (inferred).

method · [source](../src/document.rinzu#L288).

```rinzu
fn accepts(self: Document, snapshot: DocumentSnapshot) -> Bool
```

## rinzu.macos.Document.create

Checked type: `fn(String,Bool)->document::Document`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L128).

```rinzu
fn create(text: String, saved: Bool) -> Document
```

## rinzu.macos.Document.dirty

Checked type: `fn(document::Document)->Bool`.

Error contract: `nothrow` (inferred).

method · [source](../src/document.rinzu#L178).

```rinzu
fn dirty(self: Document) -> Bool
```

## rinzu.macos.Document.edit

Checked type: `fn(document::Document,String,Int,Int)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L197).

```rinzu
fn edit(self: Document, text: String, start: Int, end: Int) -> Bool
```

## rinzu.macos.Document.markSaved

Checked type: `fn(document::Document,document::DocumentSnapshot)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L281).

```rinzu
fn markSaved(self: Document, snapshot: DocumentSnapshot)
```

## rinzu.macos.Document.redoEdit

Checked type: `fn(document::Document)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L253).

```rinzu
fn redoEdit(self: Document) -> Bool
```

## rinzu.macos.Document.reset

Checked type: `fn(document::Document,String,Bool)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L156).

```rinzu
fn reset(self: Document, text: String, saved: Bool) -> Bool
```

Install another document after its read succeeds; invalidate outstanding snapshots.

## rinzu.macos.Document.select

Checked type: `fn(document::Document,Int,Int)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L182).

```rinzu
fn select(self: Document, start: Int, end: Int)
```

## rinzu.macos.Document.snapshot

Checked type: `fn(document::Document)->document::DocumentSnapshot`.

Error contract: `nothrow` (inferred).

method · [source](../src/document.rinzu#L151).

```rinzu
fn snapshot(self: Document) -> DocumentSnapshot
```

## rinzu.macos.Document.undoEdit

Checked type: `fn(document::Document)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L225).

```rinzu
fn undoEdit(self: Document) -> Bool
```

## rinzu.macos.Document.withHistory

Checked type: `fn(String,Bool,Int,Int)->document::Document`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L132).

```rinzu
fn withHistory(text: String, saved: Bool, maximumEntries: Int, maximumBytes: Int) -> Document
```

## rinzu.macos.DocumentBinding

class · [source](../src/macos.rinzu#L2908).

```rinzu
class DocumentBinding
```

A Source document bound to an existing TextView. The Window owns the native View.

### field session

[source](../src/macos.rinzu#L2909).

```rinzu
const session: Session
```

### field input

[source](../src/macos.rinzu#L2910).

```rinzu
const input: TextView
```

### field document

[source](../src/macos.rinzu#L2911).

```rinzu
const document: documents.Document
```

### field barrier

[source](../src/macos.rinzu#L2912).

```rinzu
barrier: Int
```

## rinzu.macos.DocumentBinding.capture

Checked type: `fn(DocumentBinding)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2925).

```rinzu
fn capture(self: DocumentBinding) -> Bool
```

## rinzu.macos.DocumentBinding.create

Checked type: `fn(Session,TextView,document::Document)->DocumentBinding`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2914).

```rinzu
fn create(session: Session, input: TextView, document: documents.Document) -> DocumentBinding
```

## rinzu.macos.DocumentBinding.load

Checked type: `fn(DocumentBinding,String)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2937).

```rinzu
fn load(self: DocumentBinding, text: String) -> Bool
```

Replace the document after a successful load, with fresh history and version.

## rinzu.macos.DocumentBinding.receive

Checked type: `fn(DocumentBinding,UiEvent)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2963).

```rinzu
fn receive(self: DocumentBinding, event: UiEvent) -> Bool
```

## rinzu.macos.DocumentBinding.redoEdit

Checked type: `fn(DocumentBinding)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3034).

```rinzu
fn redoEdit(self: DocumentBinding) -> Bool
```

## rinzu.macos.DocumentBinding.replace

Checked type: `fn(DocumentBinding,String,Int,Int)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2983).

```rinzu
fn replace(self: DocumentBinding, text: String, start: Int, end: Int) -> Bool
```

## rinzu.macos.DocumentBinding.setAccepting

Checked type: `fn(DocumentBinding,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3059).

```rinzu
fn setAccepting(self: DocumentBinding, accepting: Bool) -> Int
```

## rinzu.macos.DocumentBinding.undoEdit

Checked type: `fn(DocumentBinding)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3009).

```rinzu
fn undoEdit(self: DocumentBinding) -> Bool
```

## rinzu.macos.DocumentHistory

class · [source](../src/document.rinzu#L13).

```rinzu
class DocumentHistory
```

### field maximumEntries

[source](../src/document.rinzu#L14).

```rinzu
const maximumEntries: Int
```

### field maximumBytes

[source](../src/document.rinzu#L15).

```rinzu
const maximumBytes: Int
```

### field entries

[source](../src/document.rinzu#L16).

```rinzu
entries: List<DocumentSnapshot>
```

### field bytes

[source](../src/document.rinzu#L17).

```rinzu
bytes: Int
```

## rinzu.macos.DocumentHistory.clear

Checked type: `fn(document::DocumentHistory)->Unit`.

Error contract: `nothrow` (inferred).

method · [source](../src/document.rinzu#L26).

```rinzu
fn clear(self: DocumentHistory)
```

## rinzu.macos.DocumentHistory.create

Checked type: `fn(Int,Int)->document::DocumentHistory`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L19).

```rinzu
fn create(maximumEntries: Int, maximumBytes: Int) -> DocumentHistory
```

## rinzu.macos.DocumentHistory.length

Checked type: `fn(document::DocumentHistory)->Int`.

Error contract: `nothrow` (inferred).

method · [source](../src/document.rinzu#L38).

```rinzu
fn length(self: DocumentHistory) -> Int
```

## rinzu.macos.DocumentHistory.peek

Checked type: `fn(document::DocumentHistory)->Option<document::DocumentSnapshot>`.

Error contract: `nothrow` (inferred).

method · [source](../src/document.rinzu#L42).

```rinzu
fn peek(self: DocumentHistory) -> Option<DocumentSnapshot>
```

## rinzu.macos.DocumentHistory.pop

Checked type: `fn(document::DocumentHistory)->Option<document::DocumentSnapshot>`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L49).

```rinzu
fn pop(self: DocumentHistory) -> Option<DocumentSnapshot>
```

## rinzu.macos.DocumentHistory.push

Checked type: `fn(document::DocumentHistory,document::DocumentSnapshot)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/document.rinzu#L78).

```rinzu
fn push(self: DocumentHistory, snapshot: DocumentSnapshot)
```

## rinzu.macos.DocumentSnapshot

class · [source](../src/document.rinzu#L6).

```rinzu
class DocumentSnapshot
```

Immutable, transferable input for saving and background analysis.

### field text

[source](../src/document.rinzu#L7).

```rinzu
const text: String
```

### field start

[source](../src/document.rinzu#L8).

```rinzu
const start: Int
```

### field end

[source](../src/document.rinzu#L9).

```rinzu
const end: Int
```

### field version

[source](../src/document.rinzu#L10).

```rinzu
const version: Int
```

## rinzu.macos.Event

Checked type: `Event`.

native-record · [source](../src/macos.rinzu#L1151).

```rinzu
record Event
```

### field kind

[source](../src/macos.rinzu#L1152).

```rinzu
kind: Int
```

### field windowId

[source](../src/macos.rinzu#L1153).

```rinzu
windowId: Int
```

### field viewId

[source](../src/macos.rinzu#L1154).

```rinzu
viewId: Int
```

### field sequence

[source](../src/macos.rinzu#L1155).

```rinzu
sequence: Int
```

### field x

[source](../src/macos.rinzu#L1156).

```rinzu
x: Float
```

### field y

[source](../src/macos.rinzu#L1157).

```rinzu
y: Float
```

### field width

[source](../src/macos.rinzu#L1158).

```rinzu
width: Float
```

### field height

[source](../src/macos.rinzu#L1159).

```rinzu
height: Float
```

### field scale

[source](../src/macos.rinzu#L1160).

```rinzu
scale: Float
```

### field keyCode

[source](../src/macos.rinzu#L1161).

```rinzu
keyCode: Int
```

### field modifiers

[source](../src/macos.rinzu#L1162).

```rinzu
modifiers: Int
```

### field action

[source](../src/macos.rinzu#L1163).

```rinzu
action: Int
```

### field selectionStart

[source](../src/macos.rinzu#L1164).

```rinzu
selectionStart: Int
```

### field selectionEnd

[source](../src/macos.rinzu#L1165).

```rinzu
selectionEnd: Int
```

### field flags

[source](../src/macos.rinzu#L1166).

```rinzu
flags: Int
```

### field value

[source](../src/macos.rinzu#L1167).

```rinzu
value: Float
```

### field deltaX

[source](../src/macos.rinzu#L1168).

```rinzu
deltaX: Float
```

### field deltaY

[source](../src/macos.rinzu#L1169).

```rinzu
deltaY: Float
```

## rinzu.macos.Font

class · [source](../src/macos.rinzu#L341).

```rinzu
class Font
```

### field handle

[source](../src/macos.rinzu#L342).

```rinzu
const handle: FontHandle
```

## rinzu.macos.Font.destroy

Checked type: `fn(Font)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L371).

```rinzu
fn destroy(self: Font) -> Int
```

## rinzu.macos.Font.layout

Checked type: `fn(Font,String,Float,Int)->TextLayout`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L345).

```rinzu
fn layout(self: Font, text: String, width: Float, alignment: Int) -> TextLayout
```

UTF8 <=64 KiB. Width zero is natural; positive width wraps. Alignment 0/1/2.

## rinzu.macos.Font.metrics

Checked type: `fn(Font)->FontMetrics`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L358).

```rinzu
fn metrics(self: Font) -> FontMetrics
```

Unrounded CoreText face metrics in logical font points.

## rinzu.macos.FontHandle

Checked type: `FontHandle`.

opaque · [source](../src/macos.rinzu#L1020).

```rinzu
opaque FontHandle;
```

## rinzu.macos.FontMetrics

Checked type: `FontMetrics`.

native-record · [source](../src/macos.rinzu#L1080).

```rinzu
record FontMetrics
```

### field ascent

[source](../src/macos.rinzu#L1081).

```rinzu
ascent: Float
```

### field descent

[source](../src/macos.rinzu#L1082).

```rinzu
descent: Float
```

### field leading

[source](../src/macos.rinzu#L1083).

```rinzu
leading: Float
```

### field underlinePosition

[source](../src/macos.rinzu#L1084).

```rinzu
underlinePosition: Float
```

### field underlineThickness

[source](../src/macos.rinzu#L1085).

```rinzu
underlineThickness: Float
```

### field unitsPerEm

[source](../src/macos.rinzu#L1086).

```rinzu
unitsPerEm: Int
```

## rinzu.macos.Frame2D

class · [source](../src/macos.rinzu#L3604).

```rinzu
class Frame2D
```

A frame begins in AppKit points / top-left; usePixels restores Batch2D pixel units.

### field info

[source](../src/macos.rinzu#L3605).

```rinzu
const info: FrameInfo
```

### field batch

[source](../src/macos.rinzu#L3606).

```rinzu
const batch: Batch2D
```

### field width

[source](../src/macos.rinzu#L3607).

```rinzu
const width: Float
```

### field height

[source](../src/macos.rinzu#L3608).

```rinzu
const height: Float
```

## rinzu.macos.Frame2D.usePixels

Checked type: `fn(Frame2D)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3610).

```rinzu
fn usePixels(self: Frame2D)
```

## rinzu.macos.Frame2D.usePoints

Checked type: `fn(Frame2D)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3614).

```rinzu
fn usePoints(self: Frame2D)
```

## rinzu.macos.FrameClock

class · [source](../src/macos.rinzu#L376).

```rinzu
class FrameClock
```

### field handle

[source](../src/macos.rinzu#L377).

```rinzu
const handle: FrameClockHandle
```

## rinzu.macos.FrameClock.destroy

Checked type: `fn(FrameClock)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L399).

```rinzu
fn destroy(self: FrameClock) -> Int
```

## rinzu.macos.FrameClock.invalidate

Checked type: `fn(FrameClock)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L379).

```rinzu
fn invalidate(self: FrameClock) -> Int
```

## rinzu.macos.FrameClock.next

Checked type: `async(FrameClock)->Option<FrameInfo>`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L419).

```rinzu
async fn next(self: FrameClock) -> Option<FrameInfo>
```

One reader. Cancellation disarms this wait and acknowledges physical publication.

## rinzu.macos.FrameClock.presented

Checked type: `fn(FrameClock)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L391).

```rinzu
fn presented(self: FrameClock) -> Int
```

## rinzu.macos.FrameClock.retry

Checked type: `fn(FrameClock)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L387).

```rinzu
fn retry(self: FrameClock) -> Int
```

## rinzu.macos.FrameClock.setAnimating

Checked type: `fn(FrameClock,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L383).

```rinzu
fn setAnimating(self: FrameClock, enabled: Bool) -> Int
```

## rinzu.macos.FrameClock.statistics

Checked type: `fn(FrameClock)->FrameStatistics`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L403).

```rinzu
fn statistics(self: FrameClock) -> FrameStatistics
```

## rinzu.macos.FrameClock.stop

Checked type: `fn(FrameClock)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L395).

```rinzu
fn stop(self: FrameClock) -> Int
```

## rinzu.macos.FrameClockHandle

Checked type: `FrameClockHandle`.

opaque · [source](../src/macos.rinzu#L1024).

```rinzu
opaque FrameClockHandle;
```

## rinzu.macos.FrameInfo

Checked type: `FrameInfo`.

native-record · [source](../src/macos.rinzu#L1060).

```rinzu
record FrameInfo
```

### field sequence

[source](../src/macos.rinzu#L1061).

```rinzu
sequence: Int
```

### field width

[source](../src/macos.rinzu#L1062).

```rinzu
width: Int
```

### field height

[source](../src/macos.rinzu#L1063).

```rinzu
height: Int
```

### field scale

[source](../src/macos.rinzu#L1064).

```rinzu
scale: Float
```

### field time

[source](../src/macos.rinzu#L1065).

```rinzu
time: Float
```

### field delta

[source](../src/macos.rinzu#L1066).

```rinzu
delta: Float
```

## rinzu.macos.FrameStatistics

Checked type: `FrameStatistics`.

native-record · [source](../src/macos.rinzu#L1069).

```rinzu
record FrameStatistics
```

### field requests

[source](../src/macos.rinzu#L1070).

```rinzu
requests: Int
```

### field coalesced

[source](../src/macos.rinzu#L1071).

```rinzu
coalesced: Int
```

### field ticks

[source](../src/macos.rinzu#L1072).

```rinzu
ticks: Int
```

### field retries

[source](../src/macos.rinzu#L1073).

```rinzu
retries: Int
```

### field pending

[source](../src/macos.rinzu#L1074).

```rinzu
pending: CBool
```

### field visible

[source](../src/macos.rinzu#L1075).

```rinzu
visible: CBool
```

### field animating

[source](../src/macos.rinzu#L1076).

```rinzu
animating: CBool
```

### field stopped

[source](../src/macos.rinzu#L1077).

```rinzu
stopped: CBool
```

## rinzu.macos.Label

class · [source](../src/macos.rinzu#L2605).

```rinzu
class Label
```

### field view

[source](../src/macos.rinzu#L2606).

```rinzu
const view: View
```

## rinzu.macos.Label.destroy

Checked type: `fn(Label)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2612).

```rinzu
fn destroy(self: Label) -> Int
```

## rinzu.macos.Label.identity

Checked type: `fn(Label)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2608).

```rinzu
fn identity(self: Label) -> Int
```

## rinzu.macos.Label.setEnabled

Checked type: `fn(Label,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2616).

```rinzu
fn setEnabled(self: Label, enabled: Bool) -> Int
```

## rinzu.macos.Label.setText

Checked type: `fn(Label,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2624).

```rinzu
fn setText(self: Label, value: String) -> Int
```

## rinzu.macos.Label.text

Checked type: `fn(Label)->String`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2620).

```rinzu
fn text(self: Label) -> String
```

## rinzu.macos.LayoutItem

class · [source](../src/macos.rinzu#L3807).

```rinzu
class LayoutItem
```

Fixed extent plus a nonnegative proportional share of remaining space.

### field view

[source](../src/macos.rinzu#L3808).

```rinzu
const view: View
```

### field fixed

[source](../src/macos.rinzu#L3809).

```rinzu
const fixed: Float
```

### field grow

[source](../src/macos.rinzu#L3810).

```rinzu
const grow: Float
```

## rinzu.macos.Library

class · [source](../src/macos.rinzu#L449).

```rinzu
class Library
```

### field handle

[source](../src/macos.rinzu#L450).

```rinzu
const handle: LibraryHandle
```

## rinzu.macos.Library.computePipeline

Checked type: `fn(Library,String)->ComputePipeline`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L452).

```rinzu
fn computePipeline(self: Library, name: String) -> ComputePipeline
```

## rinzu.macos.Library.destroy

Checked type: `fn(Library)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L480).

```rinzu
fn destroy(self: Library) -> Int
```

## rinzu.macos.Library.renderPipeline

Checked type: `fn(Library,String,String)->RenderPipeline`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L461).

```rinzu
fn renderPipeline(self: Library, vertex: String, fragment: String) -> RenderPipeline
```

## rinzu.macos.Library.renderPipelineWithOptions

Checked type: `fn(Library,String,String,Int,Int)->RenderPipeline`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L484).

```rinzu
fn renderPipelineWithOptions(self: Library, vertex: String, fragment: String, format: Int, blend: Int)
        -> RenderPipeline
```

## rinzu.macos.LibraryHandle

Checked type: `LibraryHandle`.

opaque · [source](../src/macos.rinzu#L1026).

```rinzu
opaque LibraryHandle;
```

## rinzu.macos.Menu

class · [source](../src/macos.rinzu#L499).

```rinzu
class Menu
```

### field handle

[source](../src/macos.rinzu#L500).

```rinzu
const handle: MenuHandle
```

## rinzu.macos.Menu.addAction

Checked type: `fn(Menu,String,Int,String,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L502).

```rinzu
fn addAction(self: Menu, title: String, action: Int, key: String, modifiers: Int) -> Int
```

## rinzu.macos.Menu.addSeparator

Checked type: `fn(Menu)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L546).

```rinzu
fn addSeparator(self: Menu) -> Int
```

## rinzu.macos.Menu.addStandard

Checked type: `fn(Menu,String,Int,String,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L522).

```rinzu
fn addStandard(self: Menu, title: String, command: Int, key: String, modifiers: Int) -> Int
```

## rinzu.macos.Menu.addSubmenu

Checked type: `fn(Menu,Menu)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L542).

```rinzu
fn addSubmenu(self: Menu, child: Menu) -> Int
```

## rinzu.macos.Menu.destroy

Checked type: `fn(Menu)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L554).

```rinzu
fn destroy(self: Menu) -> Int
```

## rinzu.macos.Menu.setState

Checked type: `fn(Menu,Int,Bool,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L550).

```rinzu
fn setState(self: Menu, action: Int, enabled: Bool, isChecked: Bool) -> Int
```

## rinzu.macos.MenuHandle

Checked type: `MenuHandle`.

opaque · [source](../src/macos.rinzu#L1034).

```rinzu
opaque MenuHandle;
```

## rinzu.macos.Quad2D

class · [source](../src/macos.rinzu#L3162).

```rinzu
class Quad2D
```

Six vertices per quad; quad index (not a byte or vertex offset).

### field destination

[source](../src/macos.rinzu#L3163).

```rinzu
const destination: Rect
```

### field uv

[source](../src/macos.rinzu#L3164).

```rinzu
const uv: Rect
```

### field tint

[source](../src/macos.rinzu#L3165).

```rinzu
const tint: Color
```

### field transform

[source](../src/macos.rinzu#L3166).

```rinzu
const transform: Transform2D
```

## rinzu.macos.Rect

Checked type: `Rect`.

native-record · [source](../src/macos.rinzu#L1038).

```rinzu
record Rect
```

### field x

[source](../src/macos.rinzu#L1039).

```rinzu
x: Float
```

### field y

[source](../src/macos.rinzu#L1040).

```rinzu
y: Float
```

### field width

[source](../src/macos.rinzu#L1041).

```rinzu
width: Float
```

### field height

[source](../src/macos.rinzu#L1042).

```rinzu
height: Float
```

## rinzu.macos.RenderPipeline

class · [source](../src/macos.rinzu#L559).

```rinzu
class RenderPipeline
```

### field handle

[source](../src/macos.rinzu#L560).

```rinzu
const handle: RenderPipelineHandle
```

## rinzu.macos.RenderPipeline.destroy

Checked type: `fn(RenderPipeline)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L562).

```rinzu
fn destroy(self: RenderPipeline) -> Int
```

## rinzu.macos.RenderPipelineHandle

Checked type: `RenderPipelineHandle`.

opaque · [source](../src/macos.rinzu#L1030).

```rinzu
opaque RenderPipelineHandle;
```

## rinzu.macos.RunContext

Checked type: `{session:Session}`.

type-alias · [source](../src/macos.rinzu#L1003).

```rinzu
type RunContext = { session: Session };
```

## rinzu.macos.Sampler

class · [source](../src/macos.rinzu#L567).

```rinzu
class Sampler
```

### field handle

[source](../src/macos.rinzu#L568).

```rinzu
const handle: SamplerHandle
```

## rinzu.macos.Sampler.destroy

Checked type: `fn(Sampler)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L570).

```rinzu
fn destroy(self: Sampler) -> Int
```

## rinzu.macos.SamplerHandle

Checked type: `SamplerHandle`.

opaque · [source](../src/macos.rinzu#L1018).

```rinzu
opaque SamplerHandle;
```

## rinzu.macos.Scissor

Checked type: `Scissor`.

native-record · [source](../src/macos.rinzu#L1144).

```rinzu
record Scissor
```

### field x

[source](../src/macos.rinzu#L1145).

```rinzu
x: Int
```

### field y

[source](../src/macos.rinzu#L1146).

```rinzu
y: Int
```

### field width

[source](../src/macos.rinzu#L1147).

```rinzu
width: Int
```

### field height

[source](../src/macos.rinzu#L1148).

```rinzu
height: Int
```

## rinzu.macos.ScrollView

class · [source](../src/macos.rinzu#L2772).

```rinzu
class ScrollView
```

### field view

[source](../src/macos.rinzu#L2773).

```rinzu
const view: View
```

## rinzu.macos.ScrollView.destroy

Checked type: `fn(ScrollView)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2779).

```rinzu
fn destroy(self: ScrollView) -> Int
```

## rinzu.macos.ScrollView.identity

Checked type: `fn(ScrollView)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2775).

```rinzu
fn identity(self: ScrollView) -> Int
```

## rinzu.macos.ScrollView.scrollTo

Checked type: `fn(ScrollView,Float,Float)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2791).

```rinzu
fn scrollTo(self: ScrollView, x: Float, y: Float) -> Int
```

## rinzu.macos.ScrollView.setContent

Checked type: `fn(ScrollView,View)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2787).

```rinzu
fn setContent(self: ScrollView, content: View) -> Int
```

## rinzu.macos.ScrollView.setEnabled

Checked type: `fn(ScrollView,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2783).

```rinzu
fn setEnabled(self: ScrollView, enabled: Bool) -> Int
```

## rinzu.macos.ScrollView.visibleRect

Checked type: `fn(ScrollView)->Rect`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2795).

```rinzu
fn visibleRect(self: ScrollView) -> Rect
```

## rinzu.macos.Selection

Checked type: `Selection`.

native-record · [source](../src/macos.rinzu#L1202).

```rinzu
record Selection
```

### field start

[source](../src/macos.rinzu#L1203).

```rinzu
start: Int
```

### field end

[source](../src/macos.rinzu#L1204).

```rinzu
end: Int
```

## rinzu.macos.Session

class · [source](../src/macos.rinzu#L575).

```rinzu
class Session
```

### field handle

[source](../src/macos.rinzu#L576).

```rinzu
const handle: SessionHandle
```

## rinzu.macos.Session.button

Checked type: `fn(Session,String,Rect,Int)->Button`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L646).

```rinzu
fn button(self: Session, title: String, frame: Rect, action: Int) -> Button
```

## rinzu.macos.Session.checkbox

Checked type: `fn(Session,String,Rect,Int)->Checkbox`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L650).

```rinzu
fn checkbox(self: Session, title: String, frame: Rect, action: Int) -> Checkbox
```

## rinzu.macos.Session.clipboardText

Checked type: `fn(Session)->String`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L671).

```rinzu
fn clipboardText(self: Session) -> String
```

## rinzu.macos.Session.close

Checked type: `async(Session)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L638).

```rinzu
async fn close(self: Session) -> Int
```

## rinzu.macos.Session.device

Checked type: `fn(Session)->Device`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L626).

```rinzu
fn device(self: Session) -> Device
```

## rinzu.macos.Session.eventSequence

Checked type: `fn(Session)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L685).

```rinzu
fn eventSequence(self: Session) -> Int
```

Sequence barrier for reconciling a native snapshot with already queued input.

## rinzu.macos.Session.font

Checked type: `fn(Session,String,Float,Bool)->Font`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L689).

```rinzu
fn font(self: Session, name: String, size: Float, bold: Bool) -> Font
```

## rinzu.macos.Session.isRunning

Checked type: `fn(Session)->Bool`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L601).

```rinzu
fn isRunning(self: Session) -> Bool
```

## rinzu.macos.Session.label

Checked type: `fn(Session,String,Rect)->Label`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L642).

```rinzu
fn label(self: Session, title: String, frame: Rect) -> Label
```

## rinzu.macos.Session.nextEvent

Checked type: `async(Session)->UiEvent`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L609).

```rinzu
async fn nextEvent(self: Session) -> UiEvent
```

## rinzu.macos.Session.resourcePath

Checked type: `fn(Session,String)->String`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L588).

```rinzu
fn resourcePath(self: Session, relative: String) -> String
```

Resolve a normalized app-relative resource name without changing cwd.

## rinzu.macos.Session.resourceRoot

Checked type: `fn(Session)->Option<String>`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L579).

```rinzu
fn resourceRoot(self: Session) -> Option<String>
```

Owned absolute app-resource root; None in an ordinary JIT/console host.

## rinzu.macos.Session.run

Checked type: `async(Session,fn($rinzu_record_f7c713f12e29ebb74f67222ddd835128,Event)->Unit)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L630).

```rinzu
async fn run(self: Session, handler: fn (RunContext, Event) -> Unit) -> Int
```

## rinzu.macos.Session.runEvents

Checked type: `fn(Session)->Future<Int>`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L605).

```rinzu
fn runEvents(self: Session) -> Future<Int>
```

## rinzu.macos.Session.scrollView

Checked type: `fn(Session,Rect)->ScrollView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L662).

```rinzu
fn scrollView(self: Session, frame: Rect) -> ScrollView
```

## rinzu.macos.Session.setClipboardText

Checked type: `fn(Session,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L666).

```rinzu
fn setClipboardText(self: Session, value: String) -> Int
```

## rinzu.macos.Session.stop

Checked type: `fn(Session)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L634).

```rinzu
fn stop(self: Session) -> Int
```

## rinzu.macos.Session.textField

Checked type: `fn(Session,String,Rect,Int)->TextField`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L654).

```rinzu
fn textField(self: Session, title: String, frame: Rect, action: Int) -> TextField
```

## rinzu.macos.Session.textView

Checked type: `fn(Session,String,Rect)->TextView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L658).

```rinzu
fn textView(self: Session, title: String, frame: Rect) -> TextView
```

## rinzu.macos.Session.view

Checked type: `fn(Session,Rect)->View`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L622).

```rinzu
fn view(self: Session, rect: Rect) -> View
```

## rinzu.macos.Session.window

Checked type: `fn(Session,String,Float,Float)->Window`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L613).

```rinzu
fn window(self: Session, title: String, width: Float, height: Float) -> Window
```

## rinzu.macos.SessionHandle

Checked type: `SessionHandle`.

opaque · [source](../src/macos.rinzu#L1006).

```rinzu
opaque SessionHandle;
```

## rinzu.macos.Statistics

Checked type: `Statistics`.

native-record · [source](../src/macos.rinzu#L1172).

```rinzu
record Statistics
```

### field sessions

[source](../src/macos.rinzu#L1173).

```rinzu
sessions: Int
```

### field windows

[source](../src/macos.rinzu#L1174).

```rinzu
windows: Int
```

### field views

[source](../src/macos.rinzu#L1175).

```rinzu
views: Int
```

### field devices

[source](../src/macos.rinzu#L1176).

```rinzu
devices: Int
```

### field buffers

[source](../src/macos.rinzu#L1177).

```rinzu
buffers: Int
```

### field libraries

[source](../src/macos.rinzu#L1178).

```rinzu
libraries: Int
```

### field pipelines

[source](../src/macos.rinzu#L1179).

```rinzu
pipelines: Int
```

### field commands

[source](../src/macos.rinzu#L1180).

```rinzu
commands: Int
```

### field bufferBytes

[source](../src/macos.rinzu#L1181).

```rinzu
bufferBytes: Int
```

### field retainedControls

[source](../src/macos.rinzu#L1182).

```rinzu
retainedControls: Int
```

### field queuedEvents

[source](../src/macos.rinzu#L1183).

```rinzu
queuedEvents: Int
```

### field eventPayloadBytes

[source](../src/macos.rinzu#L1184).

```rinzu
eventPayloadBytes: Int
```

### field snapshotBytes

[source](../src/macos.rinzu#L1185).

```rinzu
snapshotBytes: Int
```

### field sheets

[source](../src/macos.rinzu#L1186).

```rinzu
sheets: Int
```

### field sheetBytes

[source](../src/macos.rinzu#L1187).

```rinzu
sheetBytes: Int
```

### field textures

[source](../src/macos.rinzu#L1188).

```rinzu
textures: Int
```

### field samplers

[source](../src/macos.rinzu#L1189).

```rinzu
samplers: Int
```

### field textureBytes

[source](../src/macos.rinzu#L1190).

```rinzu
textureBytes: Int
```

### field fonts

[source](../src/macos.rinzu#L1191).

```rinzu
fonts: Int
```

### field textLayouts

[source](../src/macos.rinzu#L1192).

```rinzu
textLayouts: Int
```

### field textBytes

[source](../src/macos.rinzu#L1193).

```rinzu
textBytes: Int
```

### field frameClocks

[source](../src/macos.rinzu#L1194).

```rinzu
frameClocks: Int
```

### field frameTimers

[source](../src/macos.rinzu#L1195).

```rinzu
frameTimers: Int
```

### field frameWaiters

[source](../src/macos.rinzu#L1196).

```rinzu
frameWaiters: Int
```

### field dataRows

[source](../src/macos.rinzu#L1197).

```rinzu
dataRows: Int
```

### field dataBytes

[source](../src/macos.rinzu#L1198).

```rinzu
dataBytes: Int
```

### field dataUpdates

[source](../src/macos.rinzu#L1199).

```rinzu
dataUpdates: Int
```

## rinzu.macos.Text2D

class · [source](../src/macos.rinzu#L3561).

```rinzu
class Text2D
```

Reusable text snapshot. Keep it across frames; reraster only after text/style changes.

### field layout

[source](../src/macos.rinzu#L3562).

```rinzu
const layout: TextLayout
```

### field texture

[source](../src/macos.rinzu#L3563).

```rinzu
const texture: Texture
```

### field metrics

[source](../src/macos.rinzu#L3564).

```rinzu
const metrics: TextMetrics
```

### field scale

[source](../src/macos.rinzu#L3565).

```rinzu
const scale: Float
```

### field width

[source](../src/macos.rinzu#L3566).

```rinzu
const width: Int
```

### field height

[source](../src/macos.rinzu#L3567).

```rinzu
const height: Int
```

## rinzu.macos.Text2D.destroy

Checked type: `fn(Text2D)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3569).

```rinzu
fn destroy(self: Text2D)
```

## rinzu.macos.TextField

class · [source](../src/macos.rinzu#L2696).

```rinzu
class TextField
```

### field view

[source](../src/macos.rinzu#L2697).

```rinzu
const view: View
```

## rinzu.macos.TextField.destroy

Checked type: `fn(TextField)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2703).

```rinzu
fn destroy(self: TextField) -> Int
```

## rinzu.macos.TextField.identity

Checked type: `fn(TextField)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2699).

```rinzu
fn identity(self: TextField) -> Int
```

## rinzu.macos.TextField.isComposing

Checked type: `fn(TextField)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2727).

```rinzu
fn isComposing(self: TextField) -> Bool
```

## rinzu.macos.TextField.select

Checked type: `fn(TextField,Int,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2723).

```rinzu
fn select(self: TextField, start: Int, end: Int) -> Int
```

## rinzu.macos.TextField.selection

Checked type: `fn(TextField)->Selection`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2719).

```rinzu
fn selection(self: TextField) -> Selection
```

## rinzu.macos.TextField.setEnabled

Checked type: `fn(TextField,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2707).

```rinzu
fn setEnabled(self: TextField, enabled: Bool) -> Int
```

## rinzu.macos.TextField.setText

Checked type: `fn(TextField,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2715).

```rinzu
fn setText(self: TextField, value: String) -> Int
```

## rinzu.macos.TextField.text

Checked type: `fn(TextField)->String`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2711).

```rinzu
fn text(self: TextField) -> String
```

## rinzu.macos.TextLayout

class · [source](../src/macos.rinzu#L699).

```rinzu
class TextLayout
```

### field handle

[source](../src/macos.rinzu#L700).

```rinzu
const handle: TextLayoutHandle
```

## rinzu.macos.TextLayout.destroy

Checked type: `fn(TextLayout)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L720).

```rinzu
fn destroy(self: TextLayout) -> Int
```

## rinzu.macos.TextLayout.metrics

Checked type: `fn(TextLayout)->TextMetrics`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L702).

```rinzu
fn metrics(self: TextLayout) -> TextMetrics
```

## rinzu.macos.TextLayoutHandle

Checked type: `TextLayoutHandle`.

opaque · [source](../src/macos.rinzu#L1022).

```rinzu
opaque TextLayoutHandle;
```

## rinzu.macos.TextMetrics

Checked type: `TextMetrics`.

native-record · [source](../src/macos.rinzu#L1089).

```rinzu
record TextMetrics
```

### field width

[source](../src/macos.rinzu#L1090).

```rinzu
width: Float
```

### field height

[source](../src/macos.rinzu#L1091).

```rinzu
height: Float
```

### field baseline

[source](../src/macos.rinzu#L1092).

```rinzu
baseline: Float
```

### field ascent

[source](../src/macos.rinzu#L1093).

```rinzu
ascent: Float
```

### field descent

[source](../src/macos.rinzu#L1094).

```rinzu
descent: Float
```

### field leading

[source](../src/macos.rinzu#L1095).

```rinzu
leading: Float
```

### field left

[source](../src/macos.rinzu#L1096).

```rinzu
left: Float
```

### field top

[source](../src/macos.rinzu#L1097).

```rinzu
top: Float
```

### field rasterWidth

[source](../src/macos.rinzu#L1098).

```rinzu
rasterWidth: Float
```

### field rasterHeight

[source](../src/macos.rinzu#L1099).

```rinzu
rasterHeight: Float
```

### field lines

[source](../src/macos.rinzu#L1100).

```rinzu
lines: Int
```

## rinzu.macos.TextView

class · [source](../src/macos.rinzu#L2734).

```rinzu
class TextView
```

### field view

[source](../src/macos.rinzu#L2735).

```rinzu
const view: View
```

## rinzu.macos.TextView.destroy

Checked type: `fn(TextView)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2741).

```rinzu
fn destroy(self: TextView) -> Int
```

## rinzu.macos.TextView.identity

Checked type: `fn(TextView)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2737).

```rinzu
fn identity(self: TextView) -> Int
```

## rinzu.macos.TextView.isComposing

Checked type: `fn(TextView)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2765).

```rinzu
fn isComposing(self: TextView) -> Bool
```

## rinzu.macos.TextView.select

Checked type: `fn(TextView,Int,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2761).

```rinzu
fn select(self: TextView, start: Int, end: Int) -> Int
```

## rinzu.macos.TextView.selection

Checked type: `fn(TextView)->Selection`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2757).

```rinzu
fn selection(self: TextView) -> Selection
```

## rinzu.macos.TextView.setEnabled

Checked type: `fn(TextView,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2745).

```rinzu
fn setEnabled(self: TextView, enabled: Bool) -> Int
```

## rinzu.macos.TextView.setText

Checked type: `fn(TextView,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2753).

```rinzu
fn setText(self: TextView, value: String) -> Int
```

## rinzu.macos.TextView.text

Checked type: `fn(TextView)->String`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2749).

```rinzu
fn text(self: TextView) -> String
```

## rinzu.macos.Texture

class · [source](../src/macos.rinzu#L725).

```rinzu
class Texture
```

### field handle

[source](../src/macos.rinzu#L726).

```rinzu
const handle: TextureHandle
```

## rinzu.macos.Texture.destroy

Checked type: `fn(Texture)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L753).

```rinzu
fn destroy(self: Texture) -> Int
```

## rinzu.macos.Texture.identity

Checked type: `fn(Texture)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L757).

```rinzu
fn identity(self: Texture) -> Int
```

## rinzu.macos.Texture.info

Checked type: `fn(Texture)->TextureInfo`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L728).

```rinzu
fn info(self: Texture) -> TextureInfo
```

## rinzu.macos.Texture.read

Checked type: `fn(Texture,Scissor)->ByteArray`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L742).

```rinzu
fn read(self: Texture, region: Scissor) -> ByteArray
```

Tightly packed owned bytes, in the texture's channel order; requires no GPU lease.

## rinzu.macos.Texture.readChannel

Checked type: `fn(Texture,Scissor,Int)->ByteArray`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L748).

```rinzu
fn readChannel(self: Texture, region: Scissor, channel: Int) -> ByteArray
```

One stored byte channel (0..3 for RGBA/BGRA, 0 for R8/Alpha8), tightly packed.

## rinzu.macos.Texture.write

Checked type: `fn(Texture,Scissor,Int,ByteArray)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L734).

```rinzu
fn write(self: Texture, region: Scissor, rowBytes: Int, bytes: ByteArray) -> Int
```

## rinzu.macos.TextureHandle

Checked type: `TextureHandle`.

opaque · [source](../src/macos.rinzu#L1016).

```rinzu
opaque TextureHandle;
```

## rinzu.macos.TextureInfo

Checked type: `TextureInfo`.

native-record · [source](../src/macos.rinzu#L1052).

```rinzu
record TextureInfo
```

### field width

[source](../src/macos.rinzu#L1053).

```rinzu
width: Int
```

### field height

[source](../src/macos.rinzu#L1054).

```rinzu
height: Int
```

### field format

[source](../src/macos.rinzu#L1055).

```rinzu
format: Int
```

### field usage

[source](../src/macos.rinzu#L1056).

```rinzu
usage: Int
```

### field bytes

[source](../src/macos.rinzu#L1057).

```rinzu
bytes: Int
```

## rinzu.macos.Transform2D

Checked type: `Transform2D`.

native-record · [source](../src/macos.rinzu#L1114).

```rinzu
record Transform2D
```

### field a

[source](../src/macos.rinzu#L1115).

```rinzu
a: Float
```

### field b

[source](../src/macos.rinzu#L1116).

```rinzu
b: Float
```

### field c

[source](../src/macos.rinzu#L1117).

```rinzu
c: Float
```

### field d

[source](../src/macos.rinzu#L1118).

```rinzu
d: Float
```

### field tx

[source](../src/macos.rinzu#L1119).

```rinzu
tx: Float
```

### field ty

[source](../src/macos.rinzu#L1120).

```rinzu
ty: Float
```

## rinzu.macos.UiAction

class · [source](../src/macos.rinzu#L3728).

```rinzu
class UiAction
```

Source-only handler storage. A binding admits one active job at a time.

### field action

[source](../src/macos.rinzu#L3729).

```rinzu
const action: Int
```

### field handler

[source](../src/macos.rinzu#L3730).

```rinzu
const handler: fn (UiJob, UiEvent) -> Future<Unit>
```

### field busy

[source](../src/macos.rinzu#L3731).

```rinzu
busy: Bool
```

## rinzu.macos.UiActions

class · [source](../src/macos.rinzu#L3734).

```rinzu
class UiActions
```

### field bindings

[source](../src/macos.rinzu#L3735).

```rinzu
bindings: List<UiAction>
```

## rinzu.macos.UiActions.handle

Checked type: `fn(UiActions,UiScope,UiEvent)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3753).

```rinzu
fn handle(self: UiActions, scope: UiScope, event: UiEvent)
```

## rinzu.macos.UiActions.on

Checked type: `fn(UiActions,Int,$rinzu_closure_735ce3cd6d5e35d7)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L3737).

```rinzu
fn on(self: UiActions, action: Int, handler: fn (UiJob, UiEvent) -> Future<Unit>)
```

## rinzu.macos.UiApplication

class · [source](../src/macos.rinzu#L2453).

```rinzu
class UiApplication
```

Application body context. Each Window keeps its own UiScope.

### field session

[source](../src/macos.rinzu#L2454).

```rinzu
const session: Session
```

### field primary

[source](../src/macos.rinzu#L2455).

```rinzu
const primary: UiScope
```

## rinzu.macos.UiControl

class · [source](../src/macos.rinzu#L1990).

```rinzu
class UiControl
```

Shared stop state contains no task handles.

### field stopping

[source](../src/macos.rinzu#L1991).

```rinzu
stopping: Bool
```

### field closed

[source](../src/macos.rinzu#L1992).

```rinzu
closed: Bool
```

## rinzu.macos.UiEvent

class · [source](../src/macos.rinzu#L1718).

```rinzu
class UiEvent
```

An owned event. Text remains valid after the native queue is acknowledged.

### field kind

[source](../src/macos.rinzu#L1719).

```rinzu
const kind: Int
```

### field windowId

[source](../src/macos.rinzu#L1720).

```rinzu
const windowId: Int
```

### field viewId

[source](../src/macos.rinzu#L1721).

```rinzu
const viewId: Int
```

### field sequence

[source](../src/macos.rinzu#L1722).

```rinzu
const sequence: Int
```

### field x

[source](../src/macos.rinzu#L1723).

```rinzu
const x: Float
```

### field y

[source](../src/macos.rinzu#L1724).

```rinzu
const y: Float
```

### field width

[source](../src/macos.rinzu#L1725).

```rinzu
const width: Float
```

### field height

[source](../src/macos.rinzu#L1726).

```rinzu
const height: Float
```

### field scale

[source](../src/macos.rinzu#L1727).

```rinzu
const scale: Float
```

### field keyCode

[source](../src/macos.rinzu#L1728).

```rinzu
const keyCode: Int
```

### field modifiers

[source](../src/macos.rinzu#L1729).

```rinzu
const modifiers: Int
```

### field action

[source](../src/macos.rinzu#L1730).

```rinzu
const action: Int
```

### field selectionStart

[source](../src/macos.rinzu#L1731).

```rinzu
const selectionStart: Int
```

### field selectionEnd

[source](../src/macos.rinzu#L1732).

```rinzu
const selectionEnd: Int
```

### field flags

[source](../src/macos.rinzu#L1733).

```rinzu
const flags: Int
```

### field value

[source](../src/macos.rinzu#L1734).

```rinzu
const value: Float
```

### field deltaX

[source](../src/macos.rinzu#L1735).

```rinzu
const deltaX: Float
```

### field deltaY

[source](../src/macos.rinzu#L1736).

```rinzu
const deltaY: Float
```

### field text

[source](../src/macos.rinzu#L1737).

```rinzu
const text: String
```

## rinzu.macos.UiJob

class · [source](../src/macos.rinzu#L1996).

```rinzu
class UiJob
```

A job receives native UI capabilities and stop state, without the job registry.

### field session

[source](../src/macos.rinzu#L1997).

```rinzu
const session: Session
```

### field window

[source](../src/macos.rinzu#L1998).

```rinzu
const window: Window
```

### field windowId

[source](../src/macos.rinzu#L1999).

```rinzu
const windowId: Int
```

### field control

[source](../src/macos.rinzu#L2000).

```rinzu
const control: UiControl
```

## rinzu.macos.UiJob.isStopping

Checked type: `fn(UiJob)->Bool`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L2002).

```rinzu
fn isStopping(self: UiJob) -> Bool
```

## rinzu.macos.UiJob.requestStop

Checked type: `fn(UiJob)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2006).

```rinzu
fn requestStop(self: UiJob)
```

## rinzu.macos.UiJob.wake

Checked type: `fn(UiJob)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2011).

```rinzu
fn wake(self: UiJob) -> Int
```

## rinzu.macos.UiScope

class · [source](../src/macos.rinzu#L2020).

```rinzu
class UiScope
```

Main-owned Window resources and Source jobs. Jobs receive a UiJob context.

### field session

[source](../src/macos.rinzu#L2021).

```rinzu
const session: Session
```

### field window

[source](../src/macos.rinzu#L2022).

```rinzu
const window: Window
```

### field windowId

[source](../src/macos.rinzu#L2023).

```rinzu
const windowId: Int
```

### field tasks

[source](../src/macos.rinzu#L2024).

```rinzu
tasks: List<UiTask>
```

### field canvases

[source](../src/macos.rinzu#L2025).

```rinzu
canvases: List<Canvas2D>
```

### field errors

[source](../src/macos.rinzu#L2026).

```rinzu
errors: List<Error>
```

### field reportedErrors

[source](../src/macos.rinzu#L2027).

```rinzu
reportedErrors: Int
```

### field control

[source](../src/macos.rinzu#L2028).

```rinzu
const control: UiControl
```

## rinzu.macos.UiScope.button

Checked type: `fn(UiScope,String,Rect,Int)->Button`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2228).

```rinzu
fn button(self: UiScope, title: String, frame: Rect, action: Int) -> Button
```

## rinzu.macos.UiScope.canvas2D

Checked type: `fn(UiScope,Device,Rect,Int,Int,Color,$rinzu_closure_efe2dcc12b934013)->Canvas2D`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2127).

```rinzu
fn canvas2D(
        self: UiScope,
        device: Device,
        frame: Rect,
        capacity: Int,
        fps: Int,
        clear: Color,
        draw: fn (Frame2D) -> Future<Unit>
    ) -> Canvas2D
```

A scope-owned drawing job. Draw callbacks stay in Source, never in AppKit.

## rinzu.macos.UiScope.checkbox

Checked type: `fn(UiScope,String,Rect,Int)->Checkbox`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2232).

```rinzu
fn checkbox(self: UiScope, title: String, frame: Rect, action: Int) -> Checkbox
```

## rinzu.macos.UiScope.close

Checked type: `async(UiScope)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2087).

```rinzu
async fn close(self: UiScope) -> Int
```

## rinzu.macos.UiScope.dispatch

Checked type: `async(UiScope,$rinzu_closure_6d2f0d3cfa7112a6)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2075).

```rinzu
async fn dispatch(self: UiScope, handler: fn (UiScope, UiEvent) -> Future<Unit>)
```

The Application has one reader. Close/quit policy stays in the Source handler.

## rinzu.macos.UiScope.dispatchActions

Checked type: `async(UiScope,UiActions)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2216).

```rinzu
async fn dispatchActions(self: UiScope, actions: UiActions)
```

## rinzu.macos.UiScope.isStopping

Checked type: `fn(UiScope)->Bool`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L2051).

```rinzu
fn isStopping(self: UiScope) -> Bool
```

## rinzu.macos.UiScope.join

Checked type: `async(UiScope)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2069).

```rinzu
async fn join(self: UiScope) -> Int
```

Join the current jobs without closing the Window; callers stop job admission first.

## rinzu.macos.UiScope.label

Checked type: `fn(UiScope,String,Rect)->Label`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2224).

```rinzu
fn label(self: UiScope, title: String, frame: Rect) -> Label
```

## rinzu.macos.UiScope.listView

Checked type: `fn(UiScope,Rect,Int)->DataView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2114).

```rinzu
fn listView(self: UiScope, frame: Rect, action: Int) -> DataView
```

## rinzu.macos.UiScope.menu

Checked type: `fn(UiScope,String)->Menu`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2248).

```rinzu
fn menu(self: UiScope, title: String) -> Menu
```

## rinzu.macos.UiScope.requestStop

Checked type: `fn(UiScope)->Unit`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2055).

```rinzu
fn requestStop(self: UiScope)
```

## rinzu.macos.UiScope.scrollView

Checked type: `fn(UiScope,Rect)->ScrollView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2244).

```rinzu
fn scrollView(self: UiScope, frame: Rect) -> ScrollView
```

## rinzu.macos.UiScope.start

Checked type: `fn(UiScope,$rinzu_closure_2671e076e7dc3bc9)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2030).

```rinzu
fn start(self: UiScope, work: fn (UiJob) -> Future<Unit>) -> Int
```

## rinzu.macos.UiScope.surface

Checked type: `fn(UiScope,Device,Rect)->View`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2108).

```rinzu
fn surface(self: UiScope, device: Device, frame: Rect) -> View
```

## rinzu.macos.UiScope.tableView

Checked type: `fn(UiScope,List<DataColumn>,Rect,Int)->DataView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2118).

```rinzu
fn tableView(self: UiScope, columns: List<DataColumn>, frame: Rect, action: Int) -> DataView
```

## rinzu.macos.UiScope.textField

Checked type: `fn(UiScope,String,Rect,Int)->TextField`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2236).

```rinzu
fn textField(self: UiScope, title: String, frame: Rect, action: Int) -> TextField
```

## rinzu.macos.UiScope.textView

Checked type: `fn(UiScope,String,Rect)->TextView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2240).

```rinzu
fn textView(self: UiScope, title: String, frame: Rect) -> TextView
```

## rinzu.macos.UiScope.treeView

Checked type: `fn(UiScope,List<DataColumn>,Rect,Int)->DataView`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2122).

```rinzu
fn treeView(self: UiScope, columns: List<DataColumn>, frame: Rect, action: Int) -> DataView
```

## rinzu.macos.UiScope.wake

Checked type: `fn(UiScope)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L2061).

```rinzu
fn wake(self: UiScope) -> Int
```

Wake the single dispatcher after Source state changes outside an input handler.

## rinzu.macos.UiTask

class · [source](../src/macos.rinzu#L1983).

```rinzu
class UiTask
```

A cooperative job registered with a UI scope. Prefer UiScope.start.

### field pending

[source](../src/macos.rinzu#L1984).

```rinzu
pending: Option<Future<Unit>>
```

### field done

[source](../src/macos.rinzu#L1985).

```rinzu
done: Bool
```

### field started

[source](../src/macos.rinzu#L1986).

```rinzu
started: Bool
```

## rinzu.macos.Vertex2D

Checked type: `Vertex2D`.

native-record · [source](../src/macos.rinzu#L1103).

```rinzu
record Vertex2D
```

### field x

[source](../src/macos.rinzu#L1104).

```rinzu
x: Float
```

### field y

[source](../src/macos.rinzu#L1105).

```rinzu
y: Float
```

### field u

[source](../src/macos.rinzu#L1106).

```rinzu
u: Float
```

### field v

[source](../src/macos.rinzu#L1107).

```rinzu
v: Float
```

### field red

[source](../src/macos.rinzu#L1108).

```rinzu
red: Float
```

### field green

[source](../src/macos.rinzu#L1109).

```rinzu
green: Float
```

### field blue

[source](../src/macos.rinzu#L1110).

```rinzu
blue: Float
```

### field alpha

[source](../src/macos.rinzu#L1111).

```rinzu
alpha: Float
```

## rinzu.macos.View

class · [source](../src/macos.rinzu#L762).

```rinzu
class View
```

### field handle

[source](../src/macos.rinzu#L763).

```rinzu
const handle: ViewHandle
```

## rinzu.macos.View.addSubview

Checked type: `fn(View,View)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L804).

```rinzu
fn addSubview(self: View, child: View) -> Int
```

## rinzu.macos.View.destroy

Checked type: `fn(View)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L812).

```rinzu
fn destroy(self: View) -> Int
```

## rinzu.macos.View.drawableSize

Checked type: `fn(View)->Rect`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L860).

```rinzu
fn drawableSize(self: View) -> Rect
```

## rinzu.macos.View.fill

Checked type: `fn(View,View,Float)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L848).

```rinzu
fn fill(self: View, parent: View, inset: Float) -> Int
```

Attach with constant insets and resize width/height with the parent.

## rinzu.macos.View.focus

Checked type: `fn(View)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L828).

```rinzu
fn focus(self: View) -> Int
```

## rinzu.macos.View.frame

Checked type: `fn(View)->Rect`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L794).

```rinzu
fn frame(self: View) -> Rect
```

## rinzu.macos.View.frameClock

Checked type: `fn(View,Int)->FrameClock`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L866).

```rinzu
fn frameClock(self: View, fps: Int) -> FrameClock
```

## rinzu.macos.View.identity

Checked type: `fn(View)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L790).

```rinzu
fn identity(self: View) -> Int
```

## rinzu.macos.View.isEnabled

Checked type: `fn(View)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L832).

```rinzu
fn isEnabled(self: View) -> Bool
```

## rinzu.macos.View.isHidden

Checked type: `fn(View)->Bool`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L837).

```rinzu
fn isHidden(self: View) -> Bool
```

## rinzu.macos.View.removeFromSuperview

Checked type: `fn(View)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L808).

```rinzu
fn removeFromSuperview(self: View) -> Int
```

## rinzu.macos.View.requestDraw

Checked type: `fn(View)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L816).

```rinzu
fn requestDraw(self: View) -> Int
```

## rinzu.macos.View.setAccessibility

Checked type: `fn(View,String,String,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L765).

```rinzu
fn setAccessibility(self: View, label: String, help: String, identifier: String) -> Int
```

## rinzu.macos.View.setAutoresizing

Checked type: `fn(View,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L843).

```rinzu
fn setAutoresizing(self: View, mask: Int) -> Int
```

AppKit bits: min-X margin 1, width 2, max-X 4, min-Y 8, height 16, max-Y 32.

## rinzu.macos.View.setEnabled

Checked type: `fn(View,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L820).

```rinzu
fn setEnabled(self: View, enabled: Bool) -> Int
```

## rinzu.macos.View.setFrame

Checked type: `fn(View,Rect)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L800).

```rinzu
fn setFrame(self: View, rect: Rect) -> Int
```

## rinzu.macos.View.setHidden

Checked type: `fn(View,Bool)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L824).

```rinzu
fn setHidden(self: View, hidden: Bool) -> Int
```

## rinzu.macos.View.setTooltip

Checked type: `fn(View,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L785).

```rinzu
fn setTooltip(self: View, text: String) -> Int
```

## rinzu.macos.ViewHandle

Checked type: `ViewHandle`.

opaque · [source](../src/macos.rinzu#L1010).

```rinzu
opaque ViewHandle;
```

## rinzu.macos.Window

class · [source](../src/macos.rinzu#L871).

```rinzu
class Window
```

### field handle

[source](../src/macos.rinzu#L872).

```rinzu
const handle: WindowHandle
```

## rinzu.macos.Window.alert

Checked type: `async(Window,String,String,String,String,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L925).

```rinzu
async fn alert(self: Window, title: String, message: String, first: String, second: String, third: String) -> Int
```

One to three buttons, numbered 1..3. Empty optional titles omit buttons. Dismissal returns 0.

## rinzu.macos.Window.command

Checked type: `fn(Window,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L910).

```rinzu
fn command(self: Window, command: Int) -> Int
```

## rinzu.macos.Window.contentView

Checked type: `fn(Window)->View`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L891).

```rinzu
fn contentView(self: Window) -> View
```

## rinzu.macos.Window.destroy

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L895).

```rinzu
fn destroy(self: Window) -> Int
```

## rinzu.macos.Window.dismissSheet

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L970).

```rinzu
fn dismissSheet(self: Window) -> Int
```

Dismiss the current sheet without closing the Window or stopping later sheets.

## rinzu.macos.Window.effectiveTheme

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L998).

```rinzu
fn effectiveTheme(self: Window) -> Int
```

## rinzu.macos.Window.hide

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L978).

```rinzu
fn hide(self: Window) -> Int
```

## rinzu.macos.Window.identity

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L874).

```rinzu
fn identity(self: Window) -> Int
```

## rinzu.macos.Window.menu

Checked type: `fn(Window,String)->Menu`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L899).

```rinzu
fn menu(self: Window, title: String) -> Menu
```

## rinzu.macos.Window.minimize

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L982).

```rinzu
fn minimize(self: Window) -> Int
```

## rinzu.macos.Window.openFile

Checked type: `fn(Window,String,String)->Future<Option<String>>`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L915).

```rinzu
fn openFile(self: Window, title: String, directory: String) -> Future<Option<String>>
```

One file, as an owned absolute path. Cancel returns None. Empty directory uses AppKit's default.

## rinzu.macos.Window.restore

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L986).

```rinzu
fn restore(self: Window) -> Int
```

## rinzu.macos.Window.saveFile

Checked type: `fn(Window,String,String,String)->Future<Option<String>>`.

Error contract: `nothrow` (inferred).

method · [source](../src/macos.rinzu#L920).

```rinzu
fn saveFile(self: Window, title: String, directory: String, name: String) -> Future<Option<String>>
```

Choose a destination; writing the file remains a separate operation.

## rinzu.macos.Window.setContentSize

Checked type: `fn(Window,Float,Float)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L887).

```rinzu
fn setContentSize(self: Window, width: Float, height: Float) -> Int
```

## rinzu.macos.Window.setMenu

Checked type: `fn(Window,Menu)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L906).

```rinzu
fn setMenu(self: Window, menu: Menu) -> Int
```

## rinzu.macos.Window.setMinimumContentSize

Checked type: `fn(Window,Float,Float)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L990).

```rinzu
fn setMinimumContentSize(self: Window, width: Float, height: Float) -> Int
```

## rinzu.macos.Window.setTheme

Checked type: `fn(Window,Int)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L994).

```rinzu
fn setTheme(self: Window, theme: Int) -> Int
```

## rinzu.macos.Window.setTitle

Checked type: `fn(Window,String)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L882).

```rinzu
fn setTitle(self: Window, title: String) -> Int
```

## rinzu.macos.Window.show

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L878).

```rinzu
fn show(self: Window) -> Int
```

## rinzu.macos.Window.state

Checked type: `fn(Window)->Int`.

Error contract: `throws(Error)` (inferred).

method · [source](../src/macos.rinzu#L974).

```rinzu
fn state(self: Window) -> Int
```

## rinzu.macos.WindowHandle

Checked type: `WindowHandle`.

opaque · [source](../src/macos.rinzu#L1008).

```rinzu
opaque WindowHandle;
```

## rinzu.macos.actionRedo

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2828).

```rinzu
let actionRedo = -2;
```

## rinzu.macos.actionUndo

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2826).

```rinzu
let actionUndo = -1;
```

## rinzu.macos.actions

Checked type: `fn()->UiActions`.

Error contract: `nothrow` (inferred).

function · [source](../src/macos.rinzu#L3802).

```rinzu
fn actions() -> UiActions
```

## rinzu.macos.addressClamp

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3189).

```rinzu
let addressClamp = 0;
```

## rinzu.macos.addressMirror

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3193).

```rinzu
let addressMirror = 2;
```

## rinzu.macos.addressRepeat

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3191).

```rinzu
let addressRepeat = 1;
```

## rinzu.macos.application

Checked type: `async(String,Float,Float,fn(UiApplication)->Future<Unit>)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L2520).

```rinzu
async fn application(title: String, width: Float, height: Float, body: fn (UiApplication) -> Future<Unit>) -> Int
```

Own the OS loop, Window, jobs and GPU resources; body runs entirely in Rinzu.

## rinzu.macos.applicationWithSignals

Checked type: `async(String,Float,Float,fn(UiApplication)->Future<Unit>)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L2525).

```rinzu
async fn applicationWithSignals(title: String, width: Float, height: Float, body: fn (UiApplication) -> Future<Unit>)
    -> Int
```

Opt into cooperative process signals, including rinzu dev cooperative restart.

## rinzu.macos.blendOpaque

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3195).

```rinzu
let blendOpaque = 0;
```

## rinzu.macos.blendPremultiplied

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3197).

```rinzu
let blendPremultiplied = 1;
```

## rinzu.macos.blendStraight

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3199).

```rinzu
let blendStraight = 2;
```

## rinzu.macos.close

Checked type: `async(Session)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L1908).

```rinzu
async fn close(session: Session) -> Int
```

Stop and await run, then join Source children before close. Drain GPU work first.

## rinzu.macos.closeOwnerSessions

Checked type: `async()->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L1931).

```rinzu
async fn closeOwnerSessions() -> Int
```

Owner-scope recovery also closes native acquisitions not yet received by Source.

## rinzu.macos.column

Checked type: `fn(View,List<View>,Float,Float)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L2877).

```rinzu
fn column(parent: View, children: List<View>, padding: Float, gap: Float) -> Int
```

## rinzu.macos.commandCopy

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2814).

```rinzu
let commandCopy = 2;
```

## rinzu.macos.commandCut

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2812).

```rinzu
let commandCut = 1;
```

## rinzu.macos.commandPaste

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2816).

```rinzu
let commandPaste = 3;
```

## rinzu.macos.commandQuit

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2824).

```rinzu
let commandQuit = 7;
```

## rinzu.macos.commandRedo

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2822).

```rinzu
let commandRedo = 6;
```

## rinzu.macos.commandSelectAll

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2818).

```rinzu
let commandSelectAll = 4;
```

## rinzu.macos.commandUndo

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2820).

```rinzu
let commandUndo = 5;
```

## rinzu.macos.compose2D

Checked type: `fn(Transform2D,Transform2D)->Transform2D`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L3244).

```rinzu
fn compose2D(first: Transform2D, next: Transform2D) -> Transform2D
```

Apply first, then next: next \* first.

## rinzu.macos.dataActivated

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4201).

```rinzu
let dataActivated = 2;
```

## rinzu.macos.dataCollapsed

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4205).

```rinzu
let dataCollapsed = 4;
```

## rinzu.macos.dataExpanded

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4203).

```rinzu
let dataExpanded = 3;
```

## rinzu.macos.dataSelected

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4199).

```rinzu
let dataSelected = 1;
```

## rinzu.macos.dataSorted

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4207).

```rinzu
let dataSorted = 5;
```

## rinzu.macos.diagnostic

Checked type: `fn()->String`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L1741).

```rinzu
fn diagnostic() -> String
```

Copy the latest Main-thread native diagnostic. Errors include this text.

## rinzu.macos.eventAction

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1703).

```rinzu
let eventAction = 12;
```

## rinzu.macos.eventCloseRequested

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1680).

```rinzu
let eventCloseRequested = 2;
```

## rinzu.macos.eventData

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4197).

```rinzu
let eventData = 20;
```

## rinzu.macos.eventDraw

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1684).

```rinzu
let eventDraw = 4;
```

## rinzu.macos.eventFocus

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1711).

```rinzu
let eventFocus = 16;
```

## rinzu.macos.eventInputLimit

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2543).

```rinzu
let eventInputLimit = 19;
```

## rinzu.macos.eventKeyDown

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1688).

```rinzu
let eventKeyDown = 6;
```

## rinzu.macos.eventKeyUp

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1690).

```rinzu
let eventKeyUp = 7;
```

## rinzu.macos.eventMouseDown

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1695).

```rinzu
let eventMouseDown = 8;
```

## rinzu.macos.eventMouseMoved

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1699).

```rinzu
let eventMouseMoved = 10;
```

## rinzu.macos.eventMouseUp

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1697).

```rinzu
let eventMouseUp = 9;
```

## rinzu.macos.eventQuitRequested

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1686).

```rinzu
let eventQuitRequested = 5;
```

## rinzu.macos.eventResized

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1682).

```rinzu
let eventResized = 3;
```

## rinzu.macos.eventScroll

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1709).

```rinzu
let eventScroll = 15;
```

## rinzu.macos.eventSelectionChanged

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1707).

```rinzu
let eventSelectionChanged = 14;
```

## rinzu.macos.eventStarted

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1678).

```rinzu
let eventStarted = 1;
```

## rinzu.macos.eventStopped

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1701).

```rinzu
let eventStopped = 11;
```

## rinzu.macos.eventTaskFinished

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1715).

```rinzu
let eventTaskFinished = 18;
```

## rinzu.macos.eventTextChanged

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1705).

```rinzu
let eventTextChanged = 13;
```

## rinzu.macos.eventWindowState

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1713).

```rinzu
let eventWindowState = 17;
```

## rinzu.macos.filterLinear

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3187).

```rinzu
let filterLinear = 1;
```

## rinzu.macos.filterNearest

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3185).

```rinzu
let filterNearest = 0;
```

## rinzu.macos.identity2D

Checked type: `fn()->Transform2D`.

Error contract: `nothrow` (inferred).

function · [source](../src/macos.rinzu#L3224).

```rinzu
fn identity2D() -> Transform2D
```

## rinzu.macos.keyRepeat

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L1693).

```rinzu
let keyRepeat = 1;
```

UiEvent.flags bit for a repeated raw key event on a native view or surface.

## rinzu.macos.metalAvailable

Checked type: `native()->Bool`.

native-function · [source](../src/macos.rinzu#L1454).

```rinzu
fn metalAvailable() -> CBool symbol "rinzu_macos_metal_available";
```

## rinzu.macos.modifierCommand

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2810).

```rinzu
let modifierCommand = 1048576;
```

## rinzu.macos.modifierControl

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2806).

```rinzu
let modifierControl = 262144;
```

## rinzu.macos.modifierOption

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2808).

```rinzu
let modifierOption = 524288;
```

## rinzu.macos.modifierShift

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L2804).

```rinzu
let modifierShift = 131072;
```

## rinzu.macos.nextEvent

Checked type: `async(Session)->UiEvent`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L1809).

```rinzu
async fn nextEvent(session: Session) -> UiEvent
```

Wait for one owned event. A single reader may be active per Session.

## rinzu.macos.open

Checked type: `fn()->Session`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L1753).

```rinzu
fn open() -> Session
```

Open one Main-owned application resource scope. Close explicitly.

## rinzu.macos.pixelAlpha8

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3177).

```rinzu
let pixelAlpha8 = 4;
```

R8Unorm coverage, sampled as (a, a, a, a) for premultiplied composition.

## rinzu.macos.pixelBGRA8

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3171).

```rinzu
let pixelBGRA8 = 2;
```

## rinzu.macos.pixelR8

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3174).

```rinzu
let pixelR8 = 3;
```

Single stored R8Unorm channel, sampled as (r, 0, 0, 1).

## rinzu.macos.pixelRGBA8

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3169).

```rinzu
let pixelRGBA8 = 1;
```

## rinzu.macos.readDocument

Checked type: `async(String)->String`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/document_files.rinzu#L8).

```rinzu
async fn readDocument(path: String) -> String
```

Read plain UTF8 with a 1 MiB bound; the enclosing Owner recovers unreceived opens.

## rinzu.macos.rotation2D

Checked type: `fn(Float)->Transform2D`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L3237).

```rinzu
fn rotation2D(radians: Float) -> Transform2D
```

Positive rotation is clockwise in the batch's top-left coordinate system.

## rinzu.macos.row

Checked type: `fn(View,List<View>,Float,Float)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L2881).

```rinzu
fn row(parent: View, children: List<View>, padding: Float, gap: Float) -> Int
```

## rinzu.macos.run

Checked type: `async(Session,fn($rinzu_record_f7c713f12e29ebb74f67222ddd835128,Event)->Unit)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L1793).

```rinzu
async fn run(session: Session, handler: fn (RunContext, Event) -> Unit) -> Int
```

Run NSApplication on Main. The handler is synchronous and valid only during run.

## rinzu.macos.runEvents

Checked type: `fn(Session)->Future<Int>`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L1803).

```rinzu
fn runEvents(session: Session) -> Future<Int>
```

## rinzu.macos.saveDocument

Checked type: `async(String,String)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/document_files.rinzu#L34).

```rinzu
async fn saveDocument(path: String, text: String) -> Int
```

Unique sibling temporary file -> bounded writes -> fsync -> atomic rename -> close.
Cancellation before installation removes the temporary during close/Owner recovery.

## rinzu.macos.scale2D

Checked type: `fn(Float,Float)->Transform2D`.

Error contract: `nothrow` (inferred).

function · [source](../src/macos.rinzu#L3232).

```rinzu
fn scale2D(x: Float, y: Float) -> Transform2D
```

## rinzu.macos.scrollPrecise

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3094).

```rinzu
let scrollPrecise = 1;
```

## rinzu.macos.scrollViewport

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3096).

```rinzu
let scrollViewport = 2;
```

## rinzu.macos.statistics

Checked type: `fn()->Statistics`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L1758).

```rinzu
fn statistics() -> Statistics
```

Measured live payloads and separately retained alias-check controls.

## rinzu.macos.stop

Checked type: `fn(Session)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L1880).

```rinzu
fn stop(session: Session) -> Int
```

## rinzu.macos.textCenter

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3577).

```rinzu
let textCenter = 1;
```

## rinzu.macos.textComposing

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3080).

```rinzu
let textComposing = 1;
```

Text snapshots with this flag are provisional IME input, outside document history.

## rinzu.macos.textLeft

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3575).

```rinzu
let textLeft = 0;
```

## rinzu.macos.textRight

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3579).

```rinzu
let textRight = 2;
```

## rinzu.macos.textureRenderTarget

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3181).

```rinzu
let textureRenderTarget = 2;
```

## rinzu.macos.textureSampled

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3179).

```rinzu
let textureSampled = 1;
```

## rinzu.macos.textureStorage

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3183).

```rinzu
let textureStorage = 4;
```

## rinzu.macos.themeDark

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4213).

```rinzu
let themeDark = 2;
```

## rinzu.macos.themeLight

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4211).

```rinzu
let themeLight = 1;
```

## rinzu.macos.themeSystem

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L4209).

```rinzu
let themeSystem = 0;
```

## rinzu.macos.translation2D

Checked type: `fn(Float,Float)->Transform2D`.

Error contract: `nothrow` (inferred).

function · [source](../src/macos.rinzu#L3228).

```rinzu
fn translation2D(x: Float, y: Float) -> Transform2D
```

## rinzu.macos.wait

Checked type: `async(Command)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L1903).

```rinzu
async fn wait(command: Command) -> Int
```

Await and physically settle a submitted command. The handle becomes reusable.

## rinzu.macos.weightedColumn

Checked type: `fn(View,List<LayoutItem>,Float,Float)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L3876).

```rinzu
fn weightedColumn(parent: View, items: List<LayoutItem>, padding: Float, gap: Float) -> Int
```

## rinzu.macos.weightedRow

Checked type: `fn(View,List<LayoutItem>,Float,Float)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L3872).

```rinzu
fn weightedRow(parent: View, items: List<LayoutItem>, padding: Float, gap: Float) -> Int
```

## rinzu.macos.windowFullScreen

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3092).

```rinzu
let windowFullScreen = 32;
```

## rinzu.macos.windowKey

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3084).

```rinzu
let windowKey = 2;
```

## rinzu.macos.windowMain

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3086).

```rinzu
let windowMain = 4;
```

## rinzu.macos.windowMinimized

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3088).

```rinzu
let windowMinimized = 8;
```

## rinzu.macos.windowVisible

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3082).

```rinzu
let windowVisible = 1;
```

## rinzu.macos.windowZoomed

Checked type: `Int`.

constant · [source](../src/macos.rinzu#L3090).

```rinzu
let windowZoomed = 16;
```

## rinzu.macos.withWindow

Checked type: `async(Session,String,Float,Float,fn(UiScope)->Future<Unit>)->Int`.

Error contract: `throws(Error)` (inferred).

function · [source](../src/macos.rinzu#L2379).

```rinzu
async fn withWindow(session: Session, title: String, width: Float, height: Float, body: fn (UiScope) -> Future<Unit>)
    -> Int
```

A Window scope within the running Application. The application has one event reader.
