#pragma once
#include "connector.h"

class Client :
	public Connector
{
public:
	Client(void);
	~Client(void);
	virtual void Init(ConSettings settings);
};

