Shader "Custom/Exam4_TexGenObjectLinear"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {TexGen ObjectLinear}
	}
	SubShader
	{
		Pass
		{
			SetTexture[_MainTex]
			{
				combine texture
			}
		}
	}
}
