using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using TMPro;

public class SceneCountTextUpdate : MonoBehaviour
{
    [SerializeField] private TextMeshProUGUI sceneCountTxt;
    // Start is called before the first frame update
    void Start()
    {
        int buildIndex = SceneManager.GetActiveScene().buildIndex;
        UpdateSceneCounter(buildIndex);
    }

    public void UpdateSceneCounter(int buildIndex)
    {
        int numOfScenes = SceneManager.sceneCountInBuildSettings;
        sceneCountTxt.text = buildIndex + 1 + " of " + numOfScenes;
    }
}
