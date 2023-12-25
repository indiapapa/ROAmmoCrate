class ROAmmoCrateLoader extends Actor;

function PostBeginPlay()
{
	WorldInfo.Game.AddMutator("ROAmmoCrate.ROAmmoCrateMutator", false);
}