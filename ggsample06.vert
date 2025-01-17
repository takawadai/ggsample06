#version 410 core

// 光源
const vec4 pl     = vec4(0.0, 0.0, 1.0, 0.0);       // 位置
const vec4 lamb   = vec4(0.2, 0.2, 0.2, 1.0);       // 環境光成分の強度
const vec4 ldiff  = vec4(1.0, 1.0, 1.0, 0.0);       // 拡散反射成分の強度
const vec4 lspec  = vec4(1.0, 1.0, 1.0, 0.0);       // 鏡面反射成分の強度

// 材質
const vec4 kamb   = vec4(0.6, 0.0, 0.0, 1.0);       // 環境光の反射係数
const vec4 kdiff  = vec4(0.6, 0.0, 0.0, 1.0);       // 拡散反射係数
const vec4 kspec  = vec4(0.4, 0.4, 0.4, 1.0);       // 鏡面反射係数
const float kshi  = 80.0;                           // 輝き係数

// 頂点属性
in vec4 pv;                                         // ローカル座標系の頂点位置
in vec4 cv;                                         // 頂点の色 → main.cpp でこれに法線ベクトル nv を入れる

// 変換行列
uniform mat4 mw;                                    // 視点座標系への変換行列
uniform mat4 mc;                                    // クリッピング座標系への変換行列
uniform mat4 mg;                                    // 法線ベクトルの変換行列

// ラスタライザに送る頂点属性
out vec4 vc;                                        // 頂点色

void main(void)
{
  // 視点座標系では視点は原点にあるので，視線ベクトルは頂点から原点に向かうベクトルである
  vec4 p = mw * pv;                                 // 視点座標系の頂点の位置
  vec3 v = -normalize(p.xyz / p.w);                 // 視線ベクトル
  vec3 l = normalize((pl * p.w - p * pl.w).xyz);    // 光線ベクトル
  vec3 n = normalize((mg * cv).xyz);                // 法線ベクトル
  float lsize = sqrt(l.x * l.x + l.y * l.y + l.z * l.z);//光線ベクトルの大きさ
  float vsize = sqrt(v.x * v.x + v.y * v.y + v.z * v.z);//視線ベクトルの大きさ
  vec3 h = (l + v)/(lsize + vsize);// 中間ベクトル

  //【宿題】下の１行（の右辺）を置き換えてください

  //環境の反射光強度
  vec4 iamb = vec4(kamb.x * lamb.x , kamb.y * lamb.y , kamb.z * lamb.z, kamb.w * lamb.w);

  //拡散反射光強度
  float NL = n.x * l.x + n.y * l.y + n.z * l.z;
  vec4 idiff = max(NL, 0) * vec4(kdiff.x * ldiff.x , kdiff.y * ldiff.y, kdiff.z * ldiff.z, kdiff.w * ldiff.w);


  //鏡面反射光強度
  float NH = n.x * h.x + n.y * h.y + n.z * h.z;
  vec4 ispec = pow(max(NH, 0), kshi) * vec4(kspec.x * lspec.x , kspec.y * lspec.y, kspec.z * lspec.z, kspec.w * lspec.w);

  vc = iamb + idiff + ispec;

  gl_Position = mc * pv;
}
