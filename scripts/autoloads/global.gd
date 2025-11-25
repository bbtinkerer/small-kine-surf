extends Node

const GAME_WIDTH := 640
const GAME_HEIGHT := 480
const GRAVITY := 980.0  #yeah i know in project settings but easier for me to just ref a global

const TIME_LIMIT: float = 60
const DEFAULT_LIVES: int = 3

var lives_setting: int = DEFAULT_LIVES
var high_score: int = 25000
var player_score: int = 0
var safe_ride_score: int = 5000
