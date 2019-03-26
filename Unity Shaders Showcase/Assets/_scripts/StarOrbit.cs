using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StarOrbit : MonoBehaviour
{
    [SerializeField] private float orbitSpeed;
    [SerializeField] private Transform orbitPoint;

    // Update is called once per frame
    void Update()
    {   
        transform.RotateAround(orbitPoint.position, Vector3.up, orbitSpeed * Time.deltaTime);
    }
}
