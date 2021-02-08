Shader "Custom/SurfaceDiffuseStregth"
{
      Properties
    {
        _Albedo("Albedo Color", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white" {}
        _NormalTex("Normal Text", 2D) = "bump" {}
        _NormalStregth("Normal Stregth", Range(-5.0, 5.0)) = 1.0
    }
    SubShader
    {
        Tags 
        { 
            "Queue" = "Geometry"
            "RenderType"="Opaque" 
        }

        CGPROGRAM
            half4 _Albedo;
            sampler2D _MainTex;
            sampler2D _NormalTex;
            float _NormalStregth;

            #pragma surface surf Lambert

            struct Input
            {
                float2 uv_MainTex;
                float2 uv_NormalTex;
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                half4 texColor = tex2D(_MainTex, IN.uv_MainTex);
                o.Albedo = _Albedo * texColor.rgb;

                half4 normalColor = tex2D(_NormalTex, IN.uv_NormalTex);
                half3 normal = UnpackNormal(normalColor);

                normal.z = normal.z / _NormalStregth;
                o.Normal = normalize(normal);
            }
        ENDCG

    }
}

