Shader "Custom/TintAndNormal"
{
    Properties
    {
        _Albedo("Albedo Color", Color) = (1, 1, 1, 1)
        // _Color("Tint Color", Color) = (1, 1 ,1 , 1)
        // [HDR] _RimColor("RimColor", Color) = (1, 0, 0, 1)
        _MainTex("Main Tex", 2D) = "white" {}
        _NormalTex("Normal Text", 2D) = "bump" {}
        _NormalStregth("Normal Stregth", Range(-5.0, 5.0)) = 1.0
        // _RimPower("Rim Power", Range(0.0, 8.0)) = 1.0
        _Emission("Emission", float) = 0
        [HDR] _EmissionColor("Color", Color) = (0,0,0)
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM
            #pragma surface surf Lambert

            fixed4 _EmissionColor;
            half4 _Albedo;
            half4 _RimColor;
            float _RimPower;
            sampler2D _MainTex;
            sampler2D _NormalTex;
            float _NormalStregth;

            struct Input
            {
                float3 viewDir;
                float2 uv_MainTex;
                float2 uv_NormalTex;
            };


            void surf(Input IN, inout SurfaceOutput o)
            {
                fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Albedo;
                o.Albedo = c.rgb;
                o.Alpha = c.a;
                o.Emission = c.rgb * tex2D(_MainTex, IN.uv_MainTex).a * _EmissionColor;

        
                half4 normalColor = tex2D(_NormalTex, IN.uv_NormalTex);
                half3 normal = UnpackNormal(normalColor);

                normal.z = normal.z / _NormalStregth;
                o.Normal = normalize(normal);

                float3 nVwd = normalize(IN.viewDir);
                float3 NdotV = dot(nVwd, o.Normal);
                float3 rim = 1 - saturate(NdotV);

                
            }
        ENDCG

    }
}
