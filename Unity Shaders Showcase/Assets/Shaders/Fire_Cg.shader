Shader "Unlit/Fire"
{
    Properties
    {
        [HDR] _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _ScrollVor ("Voronoi Scroll", Float) = 1
        _ScrollGrad ("Gradient Scroll", Float) = 1
        _DistortionAmount("Distortion Amount", Float) = 1
        _DistortionScale ("Distortion Scale", Float) = 5
        _DissolveScale("Dissolve Scale", Float) = 1
        _DissolveAmount("Dissolve Amount", Float) = 1.2
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
   
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            half _Glossiness, _Metallic;
            fixed4 _Color;
            float _ScrollVor, _ScrollGrad, _DistortionAmount, 
            _DissolveScale, _DistortionScale, _DissolveAmount;

            float2 unity_gradientNoise_dir(float2 p)
            {
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }

            float unity_gradientNoise(float2 p)
            {
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(unity_gradientNoise_dir(ip), fp);
                float d01 = dot(unity_gradientNoise_dir(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(unity_gradientNoise_dir(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(unity_gradientNoise_dir(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                return lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x);
            }

            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            {
                Out = unity_gradientNoise(UV * Scale) + 0.5;
            }

            inline float2 unity_voronoi_noise_randomVector (float2 UV, float offset)
            {
                float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
                UV = frac(sin(mul(UV, m)) * 46839.32);
                return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
            }

            void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out)
            {
                float2 g = floor(UV * CellDensity);
                float2 f = frac(UV * CellDensity);
                float t = 8.0;
                float3 res = float3(8.0, 0.0, 0.0);

                for(int y=-1; y<=1; y++)
                {
                    for(int x=-1; x<=1; x++)
                    {
                        float2 lattice = float2(x,y);
                        float2 offset = unity_voronoi_noise_randomVector(lattice + g, AngleOffset);
                        float d = distance(lattice + offset, f);
                        if(d < res.x)
                        {
                            res = float3(d, offset.x, offset.y);
                            Out = res.x;
                        }
                    }
                }
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Scroll gradient
                float2 sgrad = (0.1, _ScrollGrad);
                float2 tg = _Time * sgrad;
                tg += (1,1) * i.uv;

                // Scroll voronoi
                float2 svor = (0, _ScrollVor);
                float2 tv = _Time * svor;
                tv += (1,1) * i.uv;

                float tuvg;
                float tuvv;

                // Add gradient noise
                Unity_GradientNoise_float(tg, _DistortionScale, tuvg);

                // Add voronoi
                Unity_Voronoi_float(tv, 2, _DissolveScale, tuvv);
                tuvv = pow(tuvv, _DissolveAmount);
                float uvgradvor = tuvg * tuvv;
                i.uv = lerp(i.uv, tuvg, _DistortionAmount);

                // Sample main tex
                fixed4 c = tex2D (_MainTex, i.uv);

                fixed4 main = c * uvgradvor;
                main *= _Color;
                return main;
            }
            ENDCG
        }
    }
}
