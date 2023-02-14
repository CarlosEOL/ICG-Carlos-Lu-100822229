Shader "Custom/Rim"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Rim ("Rim Power", Range(0, 10)) = 0.0
        
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            fixed3 viewDir;
            fixed3 normalDir;
        };

        half _Glossiness;
        half _Metallic;
        half _Rim;
        fixed4 _Color;
        fixed4 _RimColor;

        fixed3 viewDir;
        fixed3 normalDir;
        

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {

            //half rim = saturate(dot(normalize(IN.viewDir), o.Normal));
            half rim = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));
            
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = pow (rim, _Rim) * 10 * _Color;
            
            o.Emission = _RimColor.rgb * pow (rim, _Rim);
            
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = o.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
