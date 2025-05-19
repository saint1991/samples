
import { Observable, of, timer } from 'rxjs';
import { switchMap,  takeWhile } from 'rxjs/operators';

interface Result {
    times: number;
}

const refresh = (i: number): Observable<Result> => {
    console.log(`Refresh ${i} - ${new Date()}`);
    return of({
        times: i,
    });
}

const refreshEvery = (seconds: number): Observable<Result> => {
    const obs = timer(0, seconds * 1000).pipe(
        switchMap(i => refresh(i)),
        takeWhile(res => res.times <= 20)
    );
    return obs;
}

const main = () => {
    refreshEvery(3).subscribe({
        next: res => {
            console.log(res)
        }
    })
};


main();