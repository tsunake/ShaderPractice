Shader "Custom/Exma1_ShowTexture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white"{}//“white”初始颜色，{}材质参数
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            sampler2D _MainTex;
            float4 _MainTex_ST;//对应TRANSFORM_TEX
            struct v2f
            {
                float4 pos: SV_POSITION;
                float2 uv: TEXCOORD0;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);//视口上的位置
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);//纹理坐标
                return o;
            }

            float4 frag(v2f i) : COLOR
            {
                float4 texCol = tex2D(_MainTex, i.uv);//某点的uv，即该点的像素取得的贴图颜色值
                return texCol;
            }
            ENDCG
        }
    }
}