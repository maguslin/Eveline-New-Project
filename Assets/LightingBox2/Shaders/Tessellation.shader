// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LightingBox/Tessellation/Tessellation Metallic"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 8.3
		_TessMin( "Tess Min Distance", Float ) = 30
		_TessMax( "Tess Max Distance", Float ) = 30
		_Displacement("Displacement", Range( -1 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 10)) = 0.3
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Color("Color", Color) = (0,0,0,0)
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		struct appdata
		{
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
			float4 texcoord1 : TEXCOORD1;
			float4 texcoord2 : TEXCOORD2;
			float4 texcoord3 : TEXCOORD3;
			fixed4 color : COLOR;
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float4 _Color;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _Displacement;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;

		float4 tessFunction( appdata v0, appdata v1, appdata v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata v )
		{
			float4 uv_Albedo = float4(v.texcoord * _Albedo_ST.xy + _Albedo_ST.zw, 0 ,0);
			float4 tex2DNode1 = tex2Dlod( _Albedo, uv_Albedo );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ( tex2DNode1.a * _Displacement ) * ase_vertexNormal );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode1 = tex2D( _Albedo, uv_Albedo );
			o.Albedo = ( _Color * tex2DNode1 ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = ( tex2DNode1.r * _Smoothness );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13101
7;29;1010;692;1550.411;408.256;1.710629;True;False
Node;AmplifyShaderEditor.RangedFloatNode;6;-909.7098,898.6682;Float;False;Property;_Displacement;Displacement;6;0;0;-1;1;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;1;-1177.297,-220.54;Float;True;Property;_Albedo;Albedo;10;0;Assets/SKY city lite/Foliage/sky___soil_AlbedoTransparency.tga;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;7;-487.5524,-409.4985;Float;False;Property;_Color;Color;9;0;0,0,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;9;-626.1172,394.2549;Float;False;Property;_Smoothness;Smoothness;7;0;0.3;0;10;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-578.6683,600.6288;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.NormalVertexDataNode;4;-625.4927,906.0804;Float;False;0;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-344.4172,115.1966;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;10;-688.8601,252.3096;Float;False;Property;_Metallic;Metallic;8;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-234.3928,-200.095;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT4;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-296.4738,600.2604;Float;False;2;2;0;FLOAT;0,0,0;False;1;FLOAT3;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.SamplerNode;2;-1172.411,6.427903;Float;True;Property;_Normal;Normal;11;0;Assets/SKY city lite/Foliage/sky___soil_Normal.tga;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;LightingBox/Tessellation/Tessellation Metallic;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;True;0;8.3;30;30;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;1;4
WireConnection;5;1;6;0
WireConnection;11;0;1;1
WireConnection;11;1;9;0
WireConnection;8;0;7;0
WireConnection;8;1;1;0
WireConnection;3;0;5;0
WireConnection;3;1;4;0
WireConnection;0;0;8;0
WireConnection;0;1;2;0
WireConnection;0;3;10;0
WireConnection;0;4;11;0
WireConnection;0;11;3;0
ASEEND*/
//CHKSM=2F2B7294F11E99717E39BB4276FB19D34B6323D8