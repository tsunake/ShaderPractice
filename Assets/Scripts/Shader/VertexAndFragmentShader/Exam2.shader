Shader "Custom/Exam2_earth"
{
    Properties
    {
        _MainTex("Earth Texture", 2D) = "white"{}
        _Cloud("Cloud Texture", 2D) = "white"{}
        _EarthSpeed("EarthSpeed", float) = -0.2
        _CloudSpeed("CloudSpeed", float) = -0.1
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Transprant"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float4 _Color;
            sampler2D _MainTex;
            sampler2D _Cloud;
            float _EarthSpeed;
            float _CloudSpeed;
            struct v2f
            {
                float4 pos:SV_POSITION;
                float2 uv:TEXCOORD0;
            };
            float4 _MainTex_ST;

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            half4 frag(v2f i):Color
            {
                float u_earth_x = i.uv.x + _EarthSpeed * _Time;
                float2 uv_earth = float2(u_earth_x, i.uv.y);
                half4 texcolor_earth = tex2D(_MainTex, uv_earth);

                float u_cloud_x = i.uv.x + _CloudSpeed * _Time;
                float2 uv_cloud = float2(u_cloud_x, i.uv.y);
                half4 texcolor_depth = tex2D(_Cloud, uv_cloud);

                half4 textcolor_cloud = float4(1,1,1,0) * texcolor_depth.x;
                return lerp(texcolor_earth, textcolor_cloud, 0.5f);
            }

            ENDCG
        }
    }
}