enum Dir {
	N, S, E, W;

	float deg() {
		switch (this) {
			case N:
				return 90.0f;

			case S:
				return 270.0f;

			case E:
				return 0.0f;

			case W:
				return 180.0f;
		}
		return 420.0f; // this is to appease the compiler
	}
}
