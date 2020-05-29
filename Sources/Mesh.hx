package;

import kha.graphics4.Graphics;
import kha.FastFloat;
import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;
import kha.graphics4.ConstantLocation;
import kha.graphics4.CompareMode;
import kha.graphics4.CullMode;
import kha.math.FastVector3;

class Mesh {

	static var vertexBuffer:VertexBuffer;
	static var indexBuffer:IndexBuffer;
	var pipeline:PipelineState;

	var mvpID:ConstantLocation;
	var modelMatrixID:ConstantLocation;

	var lightPositionC:ConstantLocation;
	var lightColorC:ConstantLocation;

	var objectAlbedoC:ConstantLocation;
	var objectAmbientOcclusionC:ConstantLocation;

	static var vertices:Array<Float> = [
		-1.0,-1.0,-1.0,
		-1.0,-1.0, 1.0,
		-1.0, 1.0, 1.0,
			1.0, 1.0,-1.0,
		-1.0,-1.0,-1.0,
		-1.0, 1.0,-1.0,
			1.0,-1.0, 1.0,
		-1.0,-1.0,-1.0,
			1.0,-1.0,-1.0,
			1.0, 1.0,-1.0,
			1.0,-1.0,-1.0,
		-1.0,-1.0,-1.0,
		-1.0,-1.0,-1.0,
		-1.0, 1.0, 1.0,
		-1.0, 1.0,-1.0,
			1.0,-1.0, 1.0,
		-1.0,-1.0, 1.0,
		-1.0,-1.0,-1.0,
		-1.0, 1.0, 1.0,
		-1.0,-1.0, 1.0,
			1.0,-1.0, 1.0,
			1.0, 1.0, 1.0,
			1.0,-1.0,-1.0,
			1.0, 1.0,-1.0,
			1.0,-1.0,-1.0,
			1.0, 1.0, 1.0,
			1.0,-1.0, 1.0,
			1.0, 1.0, 1.0,
			1.0, 1.0,-1.0,
		-1.0, 1.0,-1.0,
			1.0, 1.0, 1.0,
		-1.0, 1.0,-1.0,
		-1.0, 1.0, 1.0,
			1.0, 1.0, 1.0,
		-1.0, 1.0, 1.0,
			1.0,-1.0, 1.0
	];
	static var indices:Array<Int> = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35];
	public var normals:Array<Float> = [-4,0,0,-4,0,0,-4,0,0,-0,0,-4,-0,0,-4,-0,0,-4,0,-4,-0,0,-4,-0,0,-4,-0,0,-0,-4,0,-0,-4,0,-0,-4,-4,0,0,-4,0,0,-4,0,0,-0,-4,0,-0,-4,0,-0,-4,0,0,0,4,0,0,4,0,0,4,4,0,0,4,0,0,4,0,0,4,0,0,4,0,0,4,0,0,0,4,0,0,4,0,0,4,0,0,4,0,0,4,0,0,4,0,0,0,4,0,0,4,0,0,4];

	public var lightPosition: FastVector3 = new FastVector3(1.0, 17.7, 1.0);

	public var objectAlbedo: FastVector3 = new FastVector3(1.0, 0.5, 0.3);
	public var objectAmbientOcclusion: FastFloat = 0.2;

	public var lightColor = new FastVector3(1, 1, 1);

	public var cameraContoller: CameraController;

	public function new() {
		cameraContoller = new CameraController();
	}

	public function load() {

		var structureLength = 6;

		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		structure.add("nor", VertexData.Float3);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.fragmentShader = Shaders.shade_frag;
		pipeline.vertexShader = Shaders.shade_vert;

		pipeline.depthWrite = true;
		pipeline.depthMode = CompareMode.Less;

		pipeline.cullMode = CullMode.None;
		pipeline.compile();

		mvpID = pipeline.getConstantLocation("MVP");
		modelMatrixID = pipeline.getConstantLocation("M");

		objectAlbedoC = pipeline.getConstantLocation("objectAlbedo");
		objectAmbientOcclusionC = pipeline.getConstantLocation("objectAO");

		lightPositionC = pipeline.getConstantLocation("lightPosition");
		lightColorC = pipeline.getConstantLocation("lightColor");

		vertexBuffer = new VertexBuffer(Std.int(vertices.length / 3), structure, Usage.StaticUsage);

		var vbData = vertexBuffer.lock();
		for (i in 0...Std.int(vbData.length / structureLength)) {
			vbData.set(i * structureLength, vertices[i * 3]);
			vbData.set(i * structureLength + 1, vertices[i * 3 + 1]);
			vbData.set(i * structureLength + 2, vertices[i * 3 + 2]);
			vbData.set(i * structureLength + 3, normals[i * 3]);
			vbData.set(i * structureLength + 4, normals[i * 3 + 1]);
			vbData.set(i * structureLength + 5, normals[i * 3 + 2]);
		}
		vertexBuffer.unlock();

		indexBuffer = new IndexBuffer(indices.length*2, Usage.StaticUsage);

		var iData = indexBuffer.lock();
		for (i in 0...iData.length) {
			iData[i] = indices[i];
		}
		indexBuffer.unlock();
	}

	public function update() {
		cameraContoller.update();
	}

	public function render(g:Graphics) {
		g.begin();
		g.clear(kha.Color.fromFloats(0.7, 0.7, 0.7));
		g.setPipeline(pipeline);
		g.setVertexBuffer(vertexBuffer);
		g.setIndexBuffer(indexBuffer);
		g.setMatrix(mvpID, cameraContoller.mvp);
		g.setMatrix(modelMatrixID, cameraContoller.model);
		g.setVector3(objectAlbedoC, objectAlbedo);
		g.setFloat(objectAmbientOcclusionC, objectAmbientOcclusion);
		g.setVector3(lightPositionC, lightPosition);
		g.setVector3(lightColorC, lightColor);
		g.drawIndexedVertices();
		g.end();
	}
}
