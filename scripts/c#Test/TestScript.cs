using Godot;
using System;
using static Godot.GD;


public partial class TestScript : Node
{
	[Export] public float test = 4.0f;
	public override void _Ready()
	{
		base._Ready();
		Print("This is a test!");
	}
}
