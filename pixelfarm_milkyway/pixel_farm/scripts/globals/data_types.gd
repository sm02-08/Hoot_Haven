class_name DataTypes

enum Tools {
	None,
	AxeWood,
	TillGround,
	WaterCrops,
	PlantCorn,
	PlantTomato
}

enum GrowthStates { # new enum for plants -- corn and tomatoes 
	Seed,
	Germination,
	Vegetative,
	Reproduction,
	Maturity,
	Harvesting
}
