Shader "Custom/Double Sided Standard"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGBA)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5        
        //_GlossinessTex ("Smoothness", 2D) =  "white" {}
        _Metallic ("Metallic", Range(0,1)) = 0.0
        //_MetallicTex ("Metallic", 2D) =  "white" {}        
        _BumpMap ("NormapMap", 2D) = "bump" {}
        _Cutoff  ("Cutoff", Range(0,1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest" }
        //Tags { "RenderType"="TransparentCutout"}
        //Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
        Cull Off

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        fixed4 _Color;
        sampler2D _MainTex;
        half _Glossiness;
        sampler2D _GlossinessTex;
        half _Metallic;
        sampler2D _MetallicTex;
        sampler2D _BumpMap;        
        float _Cutoff;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_GlossinessTex;
            float2 uv_MetalicTex;
            float2 uv_BumpMap;
        };
        
        //https:forum.unity.com/threads/standard-metallic-shader-map.470334/
        //fixed4 cSpec = tex2D(_MetallicGlossMap, IN.uv_MainTex);
        //o.Metallic = cSpec.rgb;
        //o.Smoothness = _Glossiness * cSpec.a;
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 albedo = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            float3 n = UnpackNormal(tex2D (_BumpMap, IN.uv_BumpMap));
            o.Normal = n;
            o.Albedo = albedo.rgb;
            fixed4 glossiness = tex2D(_GlossinessTex, IN.uv_GlossinessTex) * _Glossiness;
            o.Smoothness = glossiness.rgb;
            fixed4 metalic = tex2D(_MetallicTex, IN.uv_MetalicTex) * _Metallic;
            o.Metallic = metalic.rgb;
            clip(albedo.a - _Cutoff);
            o.Alpha = albedo.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
