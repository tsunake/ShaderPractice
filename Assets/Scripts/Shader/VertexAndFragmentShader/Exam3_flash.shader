Shader "Custom/Exma3_flash"
{
    Properties
    {
        _MainTex("Main Texture ", 2D) = "white"{}
        _Interval("Interval", float) = 5
        _StartTime("Start Time", float) = 2
        _XLenRatio("x length ratio", Range(0.1, 1.0)) = 0.15
        _Angle("Angle", Range(1, 180)) = 80
        _AlphaBound("Alpha Bound",Range(0.0, 1.0)) = 0.5
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
        }
        Blend SrcAlpha OneMinusSrcAlpha //源色*alpha + 目标色*(1-alpha)
        AlphaTest Greater 0.1   //alpha测试，大于指定alpha值的像素才会绘制
        pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;

            struct v2f
            {
                float4 pos:SV_POSITION;
                float2 uv:TEXCOORD0;
            };
            float4 _MainTex_ST;
            float _Interval;
            float _StartTime;
            float _XLenRatio;
            float _Angle;
            float _AlphaBound;
            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }
            //75, i.uv, 0.25f, 5,
            // 2, 0.15f, 0.7f
            float inFlash(float angle, float2 uv, float xLength, int interval,
                            int beginTime, float offX, float loopTime)
            {
                //_Time	float4	t 是自该场景加载开始所经过的时间，4个分量分别是 (t/20, t, t*2, t*3)
                float brightness = 0;
                float angleInRad =  angle / 180 * 3.14;
                float currentTime = _Time.y;
                int currentTimeInt = _Time.y / interval;
                currentTimeInt * currentTimeInt;

                float currentTimePassed = currentTime - currentTimeInt;
                if(currentTimePassed > beginTime)
                {
                    float xBottomLeftBound;
                    float xBottomRightBound;
                    float xPointLeftBound;
                    float xPointRightBound;

                    float x0 = currentTimePassed - beginTime;
                    x0 /= loopTime;
                    xBottomRightBound = x0;
                    xBottomLeftBound = x0 - xLength;
                    float xProjL = (uv.y) / tan(angleInRad);
                    xPointLeftBound = xBottomLeftBound - xProjL;
                    xPointRightBound = xBottomRightBound - xProjL;
                    xPointLeftBound += offX;
                    xPointRightBound += offX;
                    if(uv.x > xPointLeftBound && uv.x < xPointRightBound)
                    {
                        float midness = (xPointLeftBound + xPointRightBound) / 2;
                        float rate = (xLength - 2 * abs(uv.x - midness)) / (xLength);
                        brightness = rate;
                    }
                }
                brightness = max(brightness, 0);
                return brightness;
            }

            float inFlash2(float angle, float2 uv, float len, float interval, float beginTime)
            {
                float brightness = 0;
                float angleInRad =  angle / 180 * 3.14;
                float currentTime = fmod(_Time.y, interval) - beginTime;
                if(currentTime <= 0)
                    return brightness;
                float xLeftBottom = currentTime / (interval - beginTime);
                float xRightBottom = xLeftBottom + len;
                float xProjL = uv.y / tan(angleInRad);
                float xLeftUp = xLeftBottom - xProjL;
                float xRightUp = xRightBottom - xProjL;
                //对每一个uv.y，在闪光区域内的点的uv.x的坐标都落在(xLeftUp,xRightUp)内
                if(uv.x > xLeftUp && uv.x < xRightUp)
                {
                    float xMiddle = (xLeftUp + xRightUp) / 2;
                    float rate = 1 - abs(uv.x - xMiddle) / len;
                    brightness = rate;
                }
                return brightness;
            }

            float4 cal1(v2f i)
            {
                float4 texCol = tex2D(_MainTex, i.uv);
                float4 outp;
                float tmpBrightness = inFlash(75, i.uv, 0.25f, 5, 2, 0.15f, 0.7f);
                if(texCol.w > 0.5)
                    outp = texCol + float4(1,1,1,1) * tmpBrightness;
                else
                    outp = float4(0,0,0,0);
                return outp;
            }

            float4 cal2(v2f i)
            {
                float4 texCol = tex2D(_MainTex, i.uv);
                float4 outp;
                float tmpBrightness = inFlash2(_Angle, i.uv, _XLenRatio, _Interval, _StartTime);
                outp = texCol;
                if(texCol.w > _AlphaBound)
                    outp = outp + float4(1,1,1,1) * tmpBrightness;
                return outp;
            }

            float4 frag(v2f i) : COLOR
            {
                //return cal1(i);
                return cal2(i);
            }
            ENDCG
        }
    }
}