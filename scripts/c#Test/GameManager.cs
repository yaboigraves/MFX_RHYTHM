using Godot;
using System;
using static Godot.GD;


public partial class GameManager : Node
{
    [Export] public float test = 4.0f;
    public override void _Ready()
    {
        base._Ready();
        GetNode<Node>("GameModeManager").Call("StartGame");
    }
}