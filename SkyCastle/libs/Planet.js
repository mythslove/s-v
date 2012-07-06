#pragma strict

var target:Transform ;

function Start () {

}

function Update () {
	var hit : RaycastHit;
	if (Physics.Raycast ( target.position, target.forward, hit, 2 )) {
		if(hit.collider.gameObject.name!="Wall"){
			transform.RotateAround(Vector3.zero, -target.right , 20*Time.deltaTime );
		}
	}else{
		transform.RotateAround(Vector3.zero, -target.right , 20*Time.deltaTime );
	}
}