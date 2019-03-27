using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using TMPro;

public class ShaderDescriptionLoader : MonoBehaviour
{
    [SerializeField] private ShaderDescription[] shaderDescriptionSOs;
    [SerializeField] private TextMeshProUGUI titleTxt;
    [SerializeField] private TextMeshProUGUI descriptionTxt;

    private void Start()
    {
        int buildIndex = SceneManager.GetActiveScene().buildIndex;
        titleTxt.text = shaderDescriptionSOs[buildIndex].ShaderName;
        descriptionTxt.text = shaderDescriptionSOs[buildIndex].Sentence;
    }
    public void LoadShaderDescription(int buildIndex)
    {
        titleTxt.text = shaderDescriptionSOs[buildIndex].ShaderName;
        descriptionTxt.text = shaderDescriptionSOs[buildIndex].Sentence;
    }
}
