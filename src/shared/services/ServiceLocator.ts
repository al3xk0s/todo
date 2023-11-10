export interface DINamedEntity<T = unknown> {
  token: string,
}

export interface IServiceLocator {
  bind<T>(entity: DINamedEntity<T>, value: T) : void;
  findByToken<T>(entity: DINamedEntity<T>) : T;
  findByTokenOrNull<T>(entity: DINamedEntity<T>) : T | undefined;
}

class ServiceLocator implements IServiceLocator {
  constructor() {
    console.log('create ioc');
  }

  private readonly _map: Map<string, any> = new Map<string, any>();

  bind<T>(entity: DINamedEntity<T>, value: T): void {
    const {token} = entity;
    if(this._map.has(token)) throw new Error(`Has token '${token}'`);

    this._map.set(token, value);
  }

  findByToken<T>(entity: DINamedEntity<T>): T {
    const value = this.findByTokenOrNull(entity);    
    if(value == null) throw new Error(`Unknown token '${entity.token}'`)

    return value;
  }

  findByTokenOrNull<T>(entity: DINamedEntity<T>): T | undefined {
    return this._map.get(entity.token) as T | undefined;
  }
}

export const IOC : IServiceLocator = new ServiceLocator();
