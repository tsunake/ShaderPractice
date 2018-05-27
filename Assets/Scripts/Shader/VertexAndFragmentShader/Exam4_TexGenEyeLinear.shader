Shader "Custom/Exam4_TexGenEyeLinear"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {TexGen EyeLinear}
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
