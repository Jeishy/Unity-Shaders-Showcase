using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ToggleScenes : MonoBehaviour
{  
    private ShaderDescriptionLoader descriptionLoader;
    private SceneCountTextUpdate sceneCountUpdate;

    private void Awake()
    {
        descriptionLoader = GetComponent<ShaderDescriptionLoader>();
        sceneCountUpdate = GetComponent<SceneCountTextUpdate>();
    }

    public void LoadLastScene()
    {
        int currentScene = SceneManager.GetActiveScene().buildIndex;
        if (currentScene > 0)
        {
            sceneCountUpdate.UpdateSceneCounter(currentScene - 1);
            SceneManager.LoadScene(currentScene - 1);
            descriptionLoader.LoadShaderDescription(currentScene - 1);
        }
    }

    public void LoadNextScene()
    {
        int currentScene = SceneManager.GetActiveScene().buildIndex;
        if (SceneManager.GetSceneByBuildIndex(currentScene).buildIndex < 2)
        {
            sceneCountUpdate.UpdateSceneCounter(currentScene + 1);
            SceneManager.LoadScene(currentScene + 1);
            descriptionLoader.LoadShaderDescription(currentScene + 1);
        }
    }
}
