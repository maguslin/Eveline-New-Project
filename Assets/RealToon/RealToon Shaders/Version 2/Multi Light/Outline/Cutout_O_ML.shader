// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//RealToon V2.0.1 Shader
//Made By MJQStudioWorks
//Made Using Shader Forge
//2017

Shader "RealToon/Version 2/Multi Light/Outline/Cutout" {
    Properties {
        [Header((RealToon V2.0.1))]
    	[Header((Multi Light x Outline))]
    	[Header((Cutout))]

        [Space(20)][Header((Texture Color))]_Texture ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (0.8,0.8,0.8,1)

        [Space(20)][Header((NormalMap))][Normal]_NormalMap ("Normal Map", 2D) = "bump" {}
        _NormalIntensity ("Normal Intensity", Float ) = 1

        [Space(20)][Header((Cutout))]_Cutout ("Cutout", Range(0, 1)) = 0
        [MaterialToggle] _AlphaBaseCutout ("Alpha Base Cutout", Float ) = -0.5

        [Space(20)][Header((Color Adjustment))]_Saturation ("Saturation", Range(0, 2)) = 1
        _ReduceWhite ("Reduce White", Range(0, 1)) = 0
        _TextureWashout ("Texture Washout", Range(0, 1)) = 0

        [Space(20)][Header((Outline))]_OutlineWidth ("Outline Width", Range(0, 1)) = 0.003
        _OutlineNoiseIntensity ("Outline Noise Intensity", Range(0, 1)) = 0
        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
        [MaterialToggle] _DynamicNoiseOutline ("Dynamic Noise Outline", Float ) = 0

        [Space(20)][Header((Self Lit))]_SelfLitIntensity ("Self Lit Intensity", Range(0, 1)) = 0
        _SelfLitPower ("Self Lit Power", Float ) = 1
        _SelfLitColor ("Self Lit Color", Color) = (1,1,1,1)
        _MaskSelfLit ("Mask Self Lit", 2D) = "white" {}

        [Space(20)][Header((Gloss))]_GlossIntensity ("Gloss Intensity", Float ) = 0
        _Glossiness ("Glossiness", Range(0, 1)) = 0.5
        _GlossColor ("Gloss Color", Color) = (1,1,1,1)
        [MaterialToggle] _MainTextureColorGloss ("Main Texture Color Gloss", Float ) = 0
        [MaterialToggle] _SoftGloss ("Soft Gloss", Float ) = 0
        [Space(8)]_GlossTextureIntensity ("Gloss Texture Intensity", Range(0, 1)) = 0
        _GlossTexture ("Gloss Texture", 2D) = "white" {}
        [MaterialToggle] _SelfShadowMaskGlossTexture ("Self Shadow Mask Gloss Texture", Float ) = 0
        [Space(8)]_GlossMask ("Gloss Mask", 2D) = "white" {}

        [Space(20)][Header((Self Shadow))]_SelfShadowIntensity ("Self Shadow Intensity", Range(0, 1)) = 1
        _SelfShadowSize ("Self Shadow Size", Range(0, 1)) = 0.56
        _SelfShadowHardness ("Self Shadow Hardness", Range(0, 1)) = 1
        _SelfShadowColor ("Self Shadow Color", Color) = (0,0,0,1)
        [MaterialToggle] _MainTextureColorSelfShadow ("Main Texture Color Self Shadow", Float ) = 0
        [MaterialToggle] _SelfShadowatViewDirection ("Self Shadow at View Direction", Float ) = 0
        [Space(8)]_SelfShadowPTextureIntensity ("Self Shadow PTexture Intensity", Range(0, 1)) = 0
        _SelfShadowPTexture ("Self Shadow PTexture", 2D) = "black" {}

        [Space(20)][Header((AO))]_AOIntensity ("AO Intensity", Range(0, 1)) = 0
        _AOTexture ("AO Texture", 2D) = "white" {}
        [MaterialToggle] _MainTextureColorAO ("Main Texture Color AO", Float ) = 0
        [MaterialToggle] _ShowAOonLight ("Show AO on Light", Float ) = 0
        [MaterialToggle] _ShowAOonAmbientLight ("Show AO on Ambient Light", Float ) = 1

        [Space(20)][Header((Lighting))][MaterialToggle] _EnableLightFalloff ("Enable Light Falloff", Float ) = 1

        [Space(20)][Header((FReflection))]_FReflectionIntensity ("FReflection Intensity", Range(0, 1)) = 0
        _FReflection ("FReflection", 2D) = "white" {}
        _MaskFReflection ("Mask FReflection", 2D) = "white" {}

        [Space(20)][Header((Fresnel))]_FresnelIntensity ("Fresnel Intensity", Range(0, 1)) = 0
        _FresnelColor ("Fresnel Color", Color) = (1,1,1,1)
        _FresnelFill ("Fresnel Fill", Float ) = 1
        [MaterialToggle] _HardEdgeFresnel ("Hard Edge Fresnel", Float ) = 0
        [MaterialToggle] _FresnelVisibleOnDarkAmbientLight ("Fresnel Visible On Dark/Ambient Light", Float ) = 0
        [MaterialToggle] _FresnelOnLight ("Fresnel On Light", Float ) = 0
        [MaterialToggle] _FresnelOnSelfShadow ("Fresnel On Self Shadow", Float ) = 0
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "Outline"
            Tags {
            }
            Cull Front
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma exclude_renderers xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _Texture; uniform float4 _Texture_ST;
            uniform float4 _OutlineColor;
            uniform float _OutlineWidth;
            uniform float _OutlineNoiseIntensity;
            uniform float _Cutout;
            uniform fixed _AlphaBaseCutout;
            uniform fixed _DynamicNoiseOutline;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                float4 node_8748 = _Time + _TimeEditor;
                float node_5371_ang = node_8748.g;
                float node_5371_spd = 0.002;
                float node_5371_cos = cos(node_5371_spd*node_5371_ang);
                float node_5371_sin = sin(node_5371_spd*node_5371_ang);
                float2 node_5371_piv = float2(0.5,0.5);
                float2 node_5371 = (mul(o.uv0-node_5371_piv,float2x2( node_5371_cos, -node_5371_sin, node_5371_sin, node_5371_cos))+node_5371_piv);
                float2 _DynamicNoiseOutline_var = lerp( o.uv0, node_5371, _DynamicNoiseOutline );
                float2 node_7493_skew = _DynamicNoiseOutline_var + 0.2127+_DynamicNoiseOutline_var.x*0.3713*_DynamicNoiseOutline_var.y;
                float2 node_7493_rnd = 4.789*sin(489.123*(node_7493_skew));
                float node_7493 = frac(node_7493_rnd.x*node_7493_rnd.y*(1+node_7493_skew.x));
                o.pos = UnityObjectToClipPos(float4(v.vertex.xyz + v.normal*(lerp(1.0,node_7493,_OutlineNoiseIntensity)*_OutlineWidth),1) );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 _Texture_var = tex2D(_Texture,TRANSFORM_TEX(i.uv0, _Texture));
                clip(lerp( (lerp(_Texture_var.rgb,dot(_Texture_var.rgb,float3(0.3,0.59,0.11)),1.0)+lerp(0.5,(-0.5),_Cutout)), saturate(( (1.0 - _Cutout) > 0.5 ? (1.0-(1.0-2.0*((1.0 - _Cutout)-0.5))*(1.0-_Texture_var.a)) : (2.0*(1.0 - _Cutout)*_Texture_var.a) )), _AlphaBaseCutout ) - 0.5);
                return fixed4(_OutlineColor.rgb,0);
            }
            ENDCG
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One OneMinusSrcAlpha
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform sampler2D _Texture; uniform float4 _Texture_ST;
            uniform float4 _Color;
            uniform float _Glossiness;
            uniform float4 _GlossColor;
            uniform float4 _SelfShadowColor;
            uniform sampler2D _NormalMap; uniform float4 _NormalMap_ST;
            uniform float _SelfShadowHardness;
            uniform float _NormalIntensity;
            uniform float _Saturation;
            uniform float _SelfShadowIntensity;
            uniform sampler2D _MaskSelfLit; uniform float4 _MaskSelfLit_ST;
            uniform sampler2D _FReflection; uniform float4 _FReflection_ST;
            uniform sampler2D _MaskFReflection; uniform float4 _MaskFReflection_ST;
            uniform float _FReflectionIntensity;
            uniform sampler2D _GlossMask; uniform float4 _GlossMask_ST;
            uniform fixed _SoftGloss;
            uniform float _SelfLitIntensity;
            uniform float _SelfShadowSize;
            uniform float _GlossIntensity;
            uniform float4 _SelfLitColor;
            uniform float _SelfLitPower;
            uniform float _ReduceWhite;
            uniform fixed _EnableLightFalloff;
            uniform float _FresnelFill;
            uniform float4 _FresnelColor;
            uniform float _FresnelIntensity;
            uniform fixed _HardEdgeFresnel;
            uniform sampler2D _SelfShadowPTexture; uniform float4 _SelfShadowPTexture_ST;
            uniform float _SelfShadowPTextureIntensity;
            uniform float _Cutout;
            uniform fixed _AlphaBaseCutout;
            uniform fixed _SelfShadowatViewDirection;
            uniform sampler2D _AOTexture; uniform float4 _AOTexture_ST;
            uniform float _AOIntensity;
            uniform fixed _ShowAOonLight;
            uniform fixed _ShowAOonAmbientLight;
            uniform fixed _MainTextureColorSelfShadow;
            uniform fixed _MainTextureColorAO;
            uniform fixed _FresnelVisibleOnDarkAmbientLight;
            uniform fixed _FresnelOnLight;
            uniform fixed _FresnelOnSelfShadow;
            uniform float _TextureWashout;
            uniform fixed _SelfShadowMaskGlossTexture;
            uniform float _GlossTextureIntensity;
            uniform sampler2D _GlossTexture; uniform float4 _GlossTexture_ST;
            uniform fixed _MainTextureColorGloss;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                float4 screenPos : TEXCOORD5;
                LIGHTING_COORDS(6,7)
                UNITY_FOG_COORDS(8)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.screenPos = o.pos;
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _NormalMap_var = UnpackNormal(tex2D(_NormalMap,TRANSFORM_TEX(i.uv0, _NormalMap)));
                float3 normalLocal = lerp(float3(0,0,1),_NormalMap_var.rgb,_NormalIntensity);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); 
                float4 _Texture_var = tex2D(_Texture,TRANSFORM_TEX(i.uv0, _Texture));
                clip(lerp( (lerp(_Texture_var.rgb,dot(_Texture_var.rgb,float3(0.3,0.59,0.11)),1.0)+lerp(0.5,(-0.5),_Cutout)), saturate(( (1.0 - _Cutout) > 0.5 ? (1.0-(1.0-2.0*((1.0 - _Cutout)-0.5))*(1.0-_Texture_var.a)) : (2.0*(1.0 - _Cutout)*_Texture_var.a) )), _AlphaBaseCutout ) - 0.5);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
////// Emissive:
                float node_6003 = pow(1.0-max(0,dot(normalDirection, viewDirection)),exp2((1.0 - _FresnelFill)));
                float _HardEdgeFresnel_var = lerp( node_6003, smoothstep( 0.38, 0.4, node_6003 ), _HardEdgeFresnel );
                float node_4586 = 1.0;
                float node_9545 = smoothstep( lerp(0.3,0.899,_SelfShadowHardness), 0.9, saturate((0.5*dot(lerp( lightDirection, viewDirection, _SelfShadowatViewDirection ),normalDirection)+0.5*lerp(2.8,0.79,_SelfShadowSize))) );
                float node_6054 = (1.0 - node_9545);
                float node_1721 = (_HardEdgeFresnel_var*lerp(0.0,_HardEdgeFresnel_var,(lerp( node_4586, node_9545, _FresnelOnLight )*lerp( node_4586, node_6054, _FresnelOnSelfShadow ))));
                float3 node_137 = ((node_1721*_FresnelColor.rgb)*_FresnelIntensity);
                float3 node_9489 = ( lerp(0.5,1.0,_TextureWashout) > 0.5 ? (1.0-(1.0-2.0*(lerp(0.5,1.0,_TextureWashout)-0.5))*(1.0-_Texture_var.rgb)) : (2.0*lerp(0.5,1.0,_TextureWashout)*_Texture_var.rgb) );
                float3 node_4607 = (node_9489*_Color.rgb);
                float3 node_6315 = ((float3(float2(i.screenPos.r,7.5),0.0)+normalDirection+float3(float2((-2.4),i.screenPos.g),0.0))*0.2);
                float4 _FReflection_var = tex2D(_FReflection,TRANSFORM_TEX(node_6315, _FReflection));
                float4 _MaskFReflection_var = tex2D(_MaskFReflection,TRANSFORM_TEX(i.uv0, _MaskFReflection));
                float3 node_3766 = lerp(node_4607,lerp(_FReflection_var.rgb,node_4607,(1.0 - _MaskFReflection_var.rgb)),_FReflectionIntensity);
                float node_5548 = 1.0;
                float node_957 = 0.0;
                float node_7783 = 1.0;
                float4 _AOTexture_var = tex2D(_AOTexture,TRANSFORM_TEX(i.uv0, _AOTexture));
                float3 node_3294 = lerp(float3(node_5548,node_5548,node_5548),lerp(lerp(float3(node_957,node_957,node_957),(node_9489*0.9),_MainTextureColorAO),float3(node_7783,node_7783,node_7783),lerp(_AOTexture_var.rgb,dot(_AOTexture_var.rgb,float3(0.3,0.59,0.11)),1.0)),lerp(0.0,lerp(1.0,10.0,_MainTextureColorAO),_AOIntensity));
                float3 node_4224 = (node_3766*UNITY_LIGHTMODEL_AMBIENT.rgb*lerp( 1.0, node_3294, _ShowAOonAmbientLight ));
                float4 _MaskSelfLit_var = tex2D(_MaskSelfLit,TRANSFORM_TEX(i.uv0, _MaskSelfLit));
                float node_5038 = (1.0 - _ReduceWhite);
                float node_3161 = (1.0 - _Saturation);
                float3 emissive = lerp(saturate(min((lerp((0.0*node_137),((node_1721*_FresnelColor.rgb)*_FresnelIntensity),_FresnelVisibleOnDarkAmbientLight)+lerp(node_4224,lerp(node_4224,(_SelfLitColor.rgb*node_3766*_SelfLitPower),_MaskSelfLit_var.rgb),lerp(0.0,1.0,_SelfLitIntensity))),node_5038)),dot(saturate(min((lerp((0.0*node_137),((node_1721*_FresnelColor.rgb)*_FresnelIntensity),_FresnelVisibleOnDarkAmbientLight)+lerp(node_4224,lerp(node_4224,(_SelfLitColor.rgb*node_3766*_SelfLitPower),_MaskSelfLit_var.rgb),lerp(0.0,1.0,_SelfLitIntensity))),node_5038)),float3(0.3,0.59,0.11)),node_3161);
                float node_2226 = 0.0;
                float node_557 = 1.0;
                float4 _SelfShadowPTexture_var = tex2D(_SelfShadowPTexture,TRANSFORM_TEX(float2(i.screenPos.x*(_ScreenParams.r/_ScreenParams.g), i.screenPos.y).rg, _SelfShadowPTexture));
                float node_3933 = 0.0;
                float node_4416 = 1.0;
                float node_7513 = 0.0;
                float node_9744 = pow(max(0,dot(normalDirection,halfDirection)),exp2(lerp(-2,15,_Glossiness)));
                float2 node_3941 = (1.0 - (reflect(viewDirection,normalDirection).rg*0.5+0.5));
                float4 _GlossTexture_var = tex2D(_GlossTexture,TRANSFORM_TEX(node_3941, _GlossTexture));
                float3 node_4842 = lerp(_GlossTexture_var.rgb,dot(_GlossTexture_var.rgb,float3(0.3,0.59,0.11)),0.0);
                float node_6475 = 0.0;
                float node_1149 = lerp((lerp( smoothstep( 0.79, 0.9, (node_9744*3.0) ), node_9744, _SoftGloss )*1.0),lerp( node_4842, lerp(float3(node_6475,node_6475,node_6475),node_4842,node_9545), _SelfShadowMaskGlossTexture ),_GlossTextureIntensity);
                float node_3921 = 0.0;
                float4 _GlossMask_var = tex2D(_GlossMask,TRANSFORM_TEX(i.uv0, _GlossMask));
                float node_2583 = 0.0;
                float node_8388_if_leA = step(_GlossIntensity,node_2583);
                float node_8388_if_leB = step(node_2583,_GlossIntensity);
                float node_4633 = 0.0;
                float3 finalColor = emissive + lerp(saturate(min((((lerp(node_3766,(node_3766*(lerp(float3(node_9545,node_9545,node_9545),lerp(lerp((node_6054*_SelfShadowColor.rgb),lerp(float3(node_2226,node_2226,node_2226),saturate((1.0-((1.0-0.44)/node_9489))),node_6054),_MainTextureColorSelfShadow),lerp((lerp(float3(node_557,node_557,node_557),_SelfShadowPTexture_var.rgb,_SelfShadowPTexture_var.a)*0.54),float3(node_3933,node_3933,node_3933),node_9545),_SelfShadowPTextureIntensity),0.65)*2.86)),lerp(0.0,lerp(1.0,2.6,_MainTextureColorSelfShadow),_SelfShadowIntensity))*lerp( lerp(node_3294,float3(node_4416,node_4416,node_4416),node_9545), node_3294, _ShowAOonLight ))+(lerp(float3(node_7513,node_7513,node_7513),lerp( lerp(float3(node_1149,node_1149,node_1149),(node_1149*_GlossColor.rgb),2.22), lerp(float3(node_3921,node_3921,node_3921),node_9489,node_1149), _MainTextureColorGloss ),_GlossMask_var.rgb)*lerp((node_8388_if_leA*node_2583)+(node_8388_if_leB*_GlossIntensity),_GlossIntensity,node_8388_if_leA*node_8388_if_leB))+lerp(node_137,float3(node_4633,node_4633,node_4633),_FresnelVisibleOnDarkAmbientLight))*(_LightColor0.rgb*lerp( step(0.001,attenuation), attenuation, _EnableLightFalloff ))),node_5038)),dot(saturate(min((((lerp(node_3766,(node_3766*(lerp(float3(node_9545,node_9545,node_9545),lerp(lerp((node_6054*_SelfShadowColor.rgb),lerp(float3(node_2226,node_2226,node_2226),saturate((1.0-((1.0-0.44)/node_9489))),node_6054),_MainTextureColorSelfShadow),lerp((lerp(float3(node_557,node_557,node_557),_SelfShadowPTexture_var.rgb,_SelfShadowPTexture_var.a)*0.54),float3(node_3933,node_3933,node_3933),node_9545),_SelfShadowPTextureIntensity),0.65)*2.86)),lerp(0.0,lerp(1.0,2.6,_MainTextureColorSelfShadow),_SelfShadowIntensity))*lerp( lerp(node_3294,float3(node_4416,node_4416,node_4416),node_9545), node_3294, _ShowAOonLight ))+(lerp(float3(node_7513,node_7513,node_7513),lerp( lerp(float3(node_1149,node_1149,node_1149),(node_1149*_GlossColor.rgb),2.22), lerp(float3(node_3921,node_3921,node_3921),node_9489,node_1149), _MainTextureColorGloss ),_GlossMask_var.rgb)*lerp((node_8388_if_leA*node_2583)+(node_8388_if_leB*_GlossIntensity),_GlossIntensity,node_8388_if_leA*node_8388_if_leB))+lerp(node_137,float3(node_4633,node_4633,node_4633),_FresnelVisibleOnDarkAmbientLight))*(_LightColor0.rgb*lerp( step(0.001,attenuation), attenuation, _EnableLightFalloff ))),node_5038)),float3(0.3,0.59,0.11)),node_3161);
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform sampler2D _Texture; uniform float4 _Texture_ST;
            uniform float4 _Color;
            uniform float _Glossiness;
            uniform float4 _GlossColor;
            uniform float4 _SelfShadowColor;
            uniform sampler2D _NormalMap; uniform float4 _NormalMap_ST;
            uniform float _SelfShadowHardness;
            uniform float _NormalIntensity;
            uniform float _Saturation;
            uniform float _SelfShadowIntensity;
            uniform sampler2D _MaskSelfLit; uniform float4 _MaskSelfLit_ST;
            uniform sampler2D _FReflection; uniform float4 _FReflection_ST;
            uniform sampler2D _MaskFReflection; uniform float4 _MaskFReflection_ST;
            uniform float _FReflectionIntensity;
            uniform sampler2D _GlossMask; uniform float4 _GlossMask_ST;
            uniform fixed _SoftGloss;
            uniform float _SelfLitIntensity;
            uniform float _SelfShadowSize;
            uniform float _GlossIntensity;
            uniform float4 _SelfLitColor;
            uniform float _SelfLitPower;
            uniform float _ReduceWhite;
            uniform fixed _EnableLightFalloff;
            uniform float _FresnelFill;
            uniform float4 _FresnelColor;
            uniform float _FresnelIntensity;
            uniform fixed _HardEdgeFresnel;
            uniform sampler2D _SelfShadowPTexture; uniform float4 _SelfShadowPTexture_ST;
            uniform float _SelfShadowPTextureIntensity;
            uniform float _Cutout;
            uniform fixed _AlphaBaseCutout;
            uniform fixed _SelfShadowatViewDirection;
            uniform sampler2D _AOTexture; uniform float4 _AOTexture_ST;
            uniform float _AOIntensity;
            uniform fixed _ShowAOonLight;
            uniform fixed _ShowAOonAmbientLight;
            uniform fixed _MainTextureColorSelfShadow;
            uniform fixed _MainTextureColorAO;
            uniform fixed _FresnelVisibleOnDarkAmbientLight;
            uniform fixed _FresnelOnLight;
            uniform fixed _FresnelOnSelfShadow;
            uniform float _TextureWashout;
            uniform fixed _SelfShadowMaskGlossTexture;
            uniform float _GlossTextureIntensity;
            uniform sampler2D _GlossTexture; uniform float4 _GlossTexture_ST;
            uniform fixed _MainTextureColorGloss;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                float4 screenPos : TEXCOORD5;
                LIGHTING_COORDS(6,7)
                UNITY_FOG_COORDS(8)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.screenPos = o.pos;
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _NormalMap_var = UnpackNormal(tex2D(_NormalMap,TRANSFORM_TEX(i.uv0, _NormalMap)));
                float3 normalLocal = lerp(float3(0,0,1),_NormalMap_var.rgb,_NormalIntensity);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); 
                float4 _Texture_var = tex2D(_Texture,TRANSFORM_TEX(i.uv0, _Texture));
                clip(lerp( (lerp(_Texture_var.rgb,dot(_Texture_var.rgb,float3(0.3,0.59,0.11)),1.0)+lerp(0.5,(-0.5),_Cutout)), saturate(( (1.0 - _Cutout) > 0.5 ? (1.0-(1.0-2.0*((1.0 - _Cutout)-0.5))*(1.0-_Texture_var.a)) : (2.0*(1.0 - _Cutout)*_Texture_var.a) )), _AlphaBaseCutout ) - 0.5);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 node_9489 = ( lerp(0.5,1.0,_TextureWashout) > 0.5 ? (1.0-(1.0-2.0*(lerp(0.5,1.0,_TextureWashout)-0.5))*(1.0-_Texture_var.rgb)) : (2.0*lerp(0.5,1.0,_TextureWashout)*_Texture_var.rgb) );
                float3 node_4607 = (node_9489*_Color.rgb);
                float3 node_6315 = ((float3(float2(i.screenPos.r,7.5),0.0)+normalDirection+float3(float2((-2.4),i.screenPos.g),0.0))*0.2);
                float4 _FReflection_var = tex2D(_FReflection,TRANSFORM_TEX(node_6315, _FReflection));
                float4 _MaskFReflection_var = tex2D(_MaskFReflection,TRANSFORM_TEX(i.uv0, _MaskFReflection));
                float3 node_3766 = lerp(node_4607,lerp(_FReflection_var.rgb,node_4607,(1.0 - _MaskFReflection_var.rgb)),_FReflectionIntensity);
                float node_9545 = smoothstep( lerp(0.3,0.899,_SelfShadowHardness), 0.9, saturate((0.5*dot(lerp( lightDirection, viewDirection, _SelfShadowatViewDirection ),normalDirection)+0.5*lerp(2.8,0.79,_SelfShadowSize))) );
                float node_6054 = (1.0 - node_9545);
                float node_2226 = 0.0;
                float node_557 = 1.0;
                float4 _SelfShadowPTexture_var = tex2D(_SelfShadowPTexture,TRANSFORM_TEX(float2(i.screenPos.x*(_ScreenParams.r/_ScreenParams.g), i.screenPos.y).rg, _SelfShadowPTexture));
                float node_3933 = 0.0;
                float node_5548 = 1.0;
                float node_957 = 0.0;
                float node_7783 = 1.0;
                float4 _AOTexture_var = tex2D(_AOTexture,TRANSFORM_TEX(i.uv0, _AOTexture));
                float3 node_3294 = lerp(float3(node_5548,node_5548,node_5548),lerp(lerp(float3(node_957,node_957,node_957),(node_9489*0.9),_MainTextureColorAO),float3(node_7783,node_7783,node_7783),lerp(_AOTexture_var.rgb,dot(_AOTexture_var.rgb,float3(0.3,0.59,0.11)),1.0)),lerp(0.0,lerp(1.0,10.0,_MainTextureColorAO),_AOIntensity));
                float node_4416 = 1.0;
                float node_7513 = 0.0;
                float node_9744 = pow(max(0,dot(normalDirection,halfDirection)),exp2(lerp(-2,15,_Glossiness)));
                float2 node_3941 = (1.0 - (reflect(viewDirection,normalDirection).rg*0.5+0.5));
                float4 _GlossTexture_var = tex2D(_GlossTexture,TRANSFORM_TEX(node_3941, _GlossTexture));
                float3 node_4842 = lerp(_GlossTexture_var.rgb,dot(_GlossTexture_var.rgb,float3(0.3,0.59,0.11)),0.0);
                float node_6475 = 0.0;
                float node_1149 = lerp((lerp( smoothstep( 0.79, 0.9, (node_9744*3.0) ), node_9744, _SoftGloss )*1.0),lerp( node_4842, lerp(float3(node_6475,node_6475,node_6475),node_4842,node_9545), _SelfShadowMaskGlossTexture ),_GlossTextureIntensity);
                float node_3921 = 0.0;
                float4 _GlossMask_var = tex2D(_GlossMask,TRANSFORM_TEX(i.uv0, _GlossMask));
                float node_2583 = 0.0;
                float node_8388_if_leA = step(_GlossIntensity,node_2583);
                float node_8388_if_leB = step(node_2583,_GlossIntensity);
                float node_6003 = pow(1.0-max(0,dot(normalDirection, viewDirection)),exp2((1.0 - _FresnelFill)));
                float _HardEdgeFresnel_var = lerp( node_6003, smoothstep( 0.38, 0.4, node_6003 ), _HardEdgeFresnel );
                float node_4586 = 1.0;
                float node_1721 = (_HardEdgeFresnel_var*lerp(0.0,_HardEdgeFresnel_var,(lerp( node_4586, node_9545, _FresnelOnLight )*lerp( node_4586, node_6054, _FresnelOnSelfShadow ))));
                float3 node_137 = ((node_1721*_FresnelColor.rgb)*_FresnelIntensity);
                float node_4633 = 0.0;
                float node_5038 = (1.0 - _ReduceWhite);
                float node_3161 = (1.0 - _Saturation);
                float3 finalColor = lerp(saturate(min((((lerp(node_3766,(node_3766*(lerp(float3(node_9545,node_9545,node_9545),lerp(lerp((node_6054*_SelfShadowColor.rgb),lerp(float3(node_2226,node_2226,node_2226),saturate((1.0-((1.0-0.44)/node_9489))),node_6054),_MainTextureColorSelfShadow),lerp((lerp(float3(node_557,node_557,node_557),_SelfShadowPTexture_var.rgb,_SelfShadowPTexture_var.a)*0.54),float3(node_3933,node_3933,node_3933),node_9545),_SelfShadowPTextureIntensity),0.65)*2.86)),lerp(0.0,lerp(1.0,2.6,_MainTextureColorSelfShadow),_SelfShadowIntensity))*lerp( lerp(node_3294,float3(node_4416,node_4416,node_4416),node_9545), node_3294, _ShowAOonLight ))+(lerp(float3(node_7513,node_7513,node_7513),lerp( lerp(float3(node_1149,node_1149,node_1149),(node_1149*_GlossColor.rgb),2.22), lerp(float3(node_3921,node_3921,node_3921),node_9489,node_1149), _MainTextureColorGloss ),_GlossMask_var.rgb)*lerp((node_8388_if_leA*node_2583)+(node_8388_if_leB*_GlossIntensity),_GlossIntensity,node_8388_if_leA*node_8388_if_leB))+lerp(node_137,float3(node_4633,node_4633,node_4633),_FresnelVisibleOnDarkAmbientLight))*(_LightColor0.rgb*lerp( step(0.001,attenuation), attenuation, _EnableLightFalloff ))),node_5038)),dot(saturate(min((((lerp(node_3766,(node_3766*(lerp(float3(node_9545,node_9545,node_9545),lerp(lerp((node_6054*_SelfShadowColor.rgb),lerp(float3(node_2226,node_2226,node_2226),saturate((1.0-((1.0-0.44)/node_9489))),node_6054),_MainTextureColorSelfShadow),lerp((lerp(float3(node_557,node_557,node_557),_SelfShadowPTexture_var.rgb,_SelfShadowPTexture_var.a)*0.54),float3(node_3933,node_3933,node_3933),node_9545),_SelfShadowPTextureIntensity),0.65)*2.86)),lerp(0.0,lerp(1.0,2.6,_MainTextureColorSelfShadow),_SelfShadowIntensity))*lerp( lerp(node_3294,float3(node_4416,node_4416,node_4416),node_9545), node_3294, _ShowAOonLight ))+(lerp(float3(node_7513,node_7513,node_7513),lerp( lerp(float3(node_1149,node_1149,node_1149),(node_1149*_GlossColor.rgb),2.22), lerp(float3(node_3921,node_3921,node_3921),node_9489,node_1149), _MainTextureColorGloss ),_GlossMask_var.rgb)*lerp((node_8388_if_leA*node_2583)+(node_8388_if_leB*_GlossIntensity),_GlossIntensity,node_8388_if_leA*node_8388_if_leB))+lerp(node_137,float3(node_4633,node_4633,node_4633),_FresnelVisibleOnDarkAmbientLight))*(_LightColor0.rgb*lerp( step(0.001,attenuation), attenuation, _EnableLightFalloff ))),node_5038)),float3(0.3,0.59,0.11)),node_3161);
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma exclude_renderers xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform sampler2D _Texture; uniform float4 _Texture_ST;
            uniform float _Cutout;
            uniform fixed _AlphaBaseCutout;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos(v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 _Texture_var = tex2D(_Texture,TRANSFORM_TEX(i.uv0, _Texture));
                clip(lerp( (lerp(_Texture_var.rgb,dot(_Texture_var.rgb,float3(0.3,0.59,0.11)),1.0)+lerp(0.5,(-0.5),_Cutout)), saturate(( (1.0 - _Cutout) > 0.5 ? (1.0-(1.0-2.0*((1.0 - _Cutout)-0.5))*(1.0-_Texture_var.a)) : (2.0*(1.0 - _Cutout)*_Texture_var.a) )), _AlphaBaseCutout ) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
}
