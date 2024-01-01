
export enum CompatibilityRestriction {
    FULL = 'FULL',
    BACKWARD = 'BACKWARD',
    FORWARD = 'FORWARD',
    NONE = 'NONE'
}

export interface Config {
    compatibility?: CompatibilityRestriction;
}