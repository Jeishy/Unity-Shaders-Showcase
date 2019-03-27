using UnityEngine;
using System.Collections;

public class HarmonicMotion : MonoBehaviour {

    public float z;
	public float v;
    public float k;

	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
		transform.Translate (new Vector3 (0, 0, v));
		float a = -k * (transform.position.z - z);
		v += a;
	}
}
