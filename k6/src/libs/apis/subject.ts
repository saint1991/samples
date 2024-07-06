import { check } from 'k6';
import http, { RefinedParams, RefinedResponse, ResponseType } from 'k6/http';

import { URL } from 'https://jslib.k6.io/url/1.0.0/index.js';

export class SubjectApi {
    
    constructor(protected readonly baseUrl: string) { }

    getAllSubjects<T extends ResponseType | undefined>(params?: RefinedParams<T>): RefinedResponse<T> {
        const path = '/subjects';
        const response = http.get<T>(`${this.baseUrl}/${path}`, params);
        check(response, {
            'status code for GET /subjects should be 200': res => res.status === 200
        });
        return response;
    }

    getSubject<T extends ResponseType | undefined>(subject: string, params?: RefinedParams<T>): RefinedResponse<T> {
        const path = `/subjects/${subject}`;
        const response = http.get<T>(`${this.baseUrl}/${path}`);
        check(response, {
            'status code for GET /subjects/{subject} should be 200': res => res.status === 200
        });
        return response;
    }

    createSubject<T extends ResponseType | undefined>(subject: string, body?: string, params?: RefinedParams<T>): RefinedResponse<T> {
        const url = new URL(`${this.baseUrl}/subjects/${subject}`);
        // const path = `/subjects/${subject}`;
        const response = http.post<T>(url.toString(), JSON.stringify(body), params);
        check(response, {
            'status code for POST /subjects/{subject} should be 201': res => res.status === 201
        });
        return response;
    }

    updateSubjectDescription<T extends ResponseType | undefined>(subject: string, description: string, params?: RefinedParams<T>): RefinedResponse<T> {
        const path = `/subjects/${subject}`;
        const response = http.put(`${this.baseUrl}/${path}`, JSON.stringify(description), params);
        check(response, {
            'status code for PUT /subjects/{subject} should be 200': res => res.status === 200
        });
        return response;
    }    

    deleteSubject<T extends ResponseType | undefined>(subject: string, params?: RefinedParams<T>): RefinedResponse<T> {
        const path = `/subjects/${subject}`;
        const response = http.del<T>(`${this.baseUrl}/${path}`, undefined, params);
        check(response, {
            'status code for DELETE /subjects/{subject} should be 200': res => res.status === 200
        });
        return response;
    }
}