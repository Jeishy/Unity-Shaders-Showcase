using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ButtonHandler : MonoBehaviour
{
    private ToggleScenes _toggleScenes;

    private void Start()
    {
        _toggleScenes = GetComponent<ToggleScenes>();
    }

    // Update is called once per frame
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.LeftArrow))
        {
            _toggleScenes.LoadLastScene();
        }
        else if (Input.GetKeyDown(KeyCode.RightArrow))
        {
            _toggleScenes.LoadNextScene();
        }
    }
}
