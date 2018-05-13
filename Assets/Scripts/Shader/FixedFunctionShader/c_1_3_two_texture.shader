Shader "Custom/c_1_3_two_texture"{
    Properties{
        _MainTex("Base (RGB)", 2D) = "white"{}
        _SubTex("Sub (RGB)", 2D) = "white"{}
        _Color("Main Color", Color) = (1,1,1,1)
    }

    SubShader{
        Pass{
            Material
            {
                Diffuse[_Color]
            }
            Lighting On
            SetTexture[_MainTex]{
                Combine texture * primary
            }
            SetTexture[_SubTex]{
                Combine texture * previous
            }
        }
    }
}