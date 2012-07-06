#pragma strict

function Start () {
	
}

function Update () {

	if( Input.GetKey(KeyCode.A)){
		transform.Rotate(-Vector3.up*50*Time.deltaTime);
	}else if( Input.GetKey(KeyCode.D)){
		transform.Rotate(Vector3.up*50*Time.deltaTime);
	}
}