import { check } from 'k6';
import http, { RefinedParams, RefinedResponse, ResponseType } from 'k6/http';

import { type Schema } from '../models/schema'; 

export class SchemaApi {
    constructor(protected readonly baseUrl: string) { }

    registerSchema<T extends ResponseType | undefined>(subject: string, body: object, params?: RefinedParams<T>): RefinedResponse<T> {
        const path = `/subjects/${subject}/versions`;
        const response = http.post(`${this.baseUrl}${path}`, JSON.stringify(body), params);
        check(response, {
            'status code for POST /subjects/{subject}/versions should be 200 or 201': res => res.status === 200 || res.status === 201
        });
        return response;
    }
}