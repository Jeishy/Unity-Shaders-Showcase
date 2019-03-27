using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "ScriptableObjects/ShaderDescription")]
public class ShaderDescription : ScriptableObject
{
    public string ShaderName;
    [TextArea]
    public string Sentence;
}
