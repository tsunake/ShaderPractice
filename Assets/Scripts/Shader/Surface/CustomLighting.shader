Shader "Custom/CustomLighting" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		[MaterialToggle] _WithDiifuse("WithDiifuse", Float) = 0
	}
	SubShader {
		AlphaTest Greater 0.4
		CGPROGRAM
		#pragma surface surf CustomLightModel
		sampler2D _MainTex;
		float _WithDiifuse;
		struct Input {
			float2 uv_MainTex;
		};
		//lightDir光的方向
		//viewDir视线方向，用于计算镜面反射
		float4 LightingCustomLightModel(SurfaceOutput s, float3 lightDir, half3 viewDir, half atten)
		{
			float4 c;
			//漫反射强度
			float diffuseF = max(0, dot(s.Normal, lightDir));
			//镜面强度
			float3 outLight = normalize(lightDir + viewDir);
			float specBase = max(0, dot(s.Normal, outLight));
			float specularF = pow(specBase, 8);
			if(_WithDiifuse == 1)
			{
				c.rgb = s.Albedo * _LightColor0 * diffuseF * atten + _LightColor0 * specularF;
			}
			else
			{
				c.rgb = _LightColor0 * specularF;
			}
			c.a = s.Alpha;
			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
}
